import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_datos;
import 'package:timezone/timezone.dart' as tz;

import '../models_books/loan.dart';

// Servicio de notificaciones locales: avisa del préstamo y recuerda la devolución.
class NotificacionService {
  NotificacionService._internal();
  static final NotificacionService instance = NotificacionService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _listo = false;

  // Canal de Android: agrupa las notificaciones de préstamos.
  static const _detalles = NotificationDetails(
    android: AndroidNotificationDetails(
      'prestamos',
      'Préstamos',
      channelDescription: 'Avisos de préstamos y devoluciones de libros',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  // Se llama una vez al abrir la app (main.dart).
  Future<void> iniciar() async {
    // Las notificaciones programadas necesitan una zona horaria: se usa la de Bogotá.
    tz_datos.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Bogota'));

    const ajustes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
    );
    await _plugin.initialize(ajustes);
    _listo = true;
  }

  // Pide el permiso de notificaciones (Android 13 o superior).
  // Devuelve true si el usuario lo concedió.
  Future<bool> pedirPermiso() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final concedido = await android?.requestNotificationsPermission();
    return concedido ?? false;
  }

  // Lo usa la pantalla de préstamos: pide el permiso, avisa al instante y
  // programa el recordatorio. Devuelve false si falta el permiso.
  Future<bool> notificarPrestamo(Loan prestamo) async {
    if (!_listo) return false;
    if (!await pedirPermiso()) return false;

    // Un id distinto por préstamo: uno para el aviso y otro para el recordatorio.
    final base = DateTime.now().millisecondsSinceEpoch % 100000000;
    await _mostrarPrestamoRegistrado(base * 2, prestamo);
    await _programarRecordatorio(base * 2 + 1, prestamo);
    return true;
  }

  // Notificación inmediata: confirma el préstamo y la fecha de devolución.
  Future<void> _mostrarPrestamoRegistrado(int id, Loan prestamo) {
    return _plugin.show(
      id,
      'Préstamo registrado',
      '"${prestamo.book.title}" para ${prestamo.user}. '
          'Devuélvelo el ${formatDate(prestamo.dueDate)}.',
      _detalles,
    );
  }

  // Recordatorio: un día antes de la devolución, a las 9:00 a. m.
  Future<void> _programarRecordatorio(int id, Loan prestamo) async {
    final diaAntes = prestamo.dueDate.subtract(const Duration(days: 1));
    final hora = tz.TZDateTime(
      tz.local,
      diaAntes.year,
      diaAntes.month,
      diaAntes.day,
      9,
    );

    // Si esa hora ya pasó (por ejemplo, préstamo con fecha antigua),
    // el aviso se muestra de inmediato en lugar de programarlo.
    if (!hora.isAfter(tz.TZDateTime.now(tz.local))) {
      final hoy = DateTime.now();
      final vencido = !prestamo.dueDate.isAfter(
        DateTime(hoy.year, hoy.month, hoy.day),
      );
      await _plugin.show(
        id,
        'Recordatorio de devolución',
        vencido
            ? 'El préstamo de "${prestamo.book.title}" venció el ${formatDate(prestamo.dueDate)}.'
            : 'El préstamo de "${prestamo.book.title}" vence el ${formatDate(prestamo.dueDate)}.',
        _detalles,
      );
      return;
    }

    // Programación aproximada: no necesita el permiso de alarmas exactas.
    await _plugin.zonedSchedule(
      id,
      'Recordatorio de devolución',
      'Mañana vence el préstamo de "${prestamo.book.title}".',
      hora,
      _detalles,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
