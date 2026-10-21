import 'package:flutter/material.dart';
import '../models_books/book.dart';

class SearchBooksView extends StatelessWidget {
  const SearchBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _SearchBar(),
        SizedBox(height: 12),
        Expanded(child: BookCatalog()),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          showSearch(context: context, delegate: _CustomSearchDelegate());
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                'Buscar libros...',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCatalog extends StatelessWidget {
  const BookCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Book>>(
      valueListenable: books,
      builder: (context, currentBooks, _) {
        return ListView.builder(
          itemCount: currentBooks.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.book),
              title: Text(currentBooks[index].title),
              subtitle: Text(currentBooks[index].author),
            );
          }
        );
      }
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _searchBooks(query);
    if (results.isEmpty) {
      return const Center(child: Text("Sin resultados"));
    }
    return _buildBookList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _searchBooks(query);
    if (query.isEmpty) {
      return const Center(child: Text("Escribe el nombre de un libro o autor"));
    }
    if (suggestions.isEmpty) {
      return const Center(child: Text("Sin coincidencias"));
    }
    return _buildBookList(suggestions);
  }

  List<Book> _searchBooks(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return books.value;
    }
    return books.value
        .where(
          (book) =>
              book.title.toLowerCase().contains(q) ||
              book.author.toLowerCase().contains(q),
        )
        .toList();
  }

  Widget _buildBookList(List<Book> books) {
    return ListView.separated(
      itemCount: books.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);
          },
        );
      },
    );
  }
}