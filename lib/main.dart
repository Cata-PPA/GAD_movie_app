import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MoviesPage(),
    );
  }
}

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final List<String> _titles = <String>[];
  final List<String> _images = <String>[];
  bool _isLoading = true;
  final PageController controller = PageController(
    initialPage: 1,
  );

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  void _getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;

      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<Map<dynamic, dynamic>> movies = List<Map<dynamic, dynamic>>.from(data['movies'] as List<dynamic>);

      for (final Map<dynamic, dynamic> item in movies) {
        _titles.add(item['title'] as String);
        _images.add(item['medium_cover_image'] as String);
      }

      final Iterable<String> items =
          movies.cast<Map<dynamic, dynamic>>().map((Map<dynamic, dynamic> item) => item['title'] as String);

      setState(() {
        _titles.addAll(items);
        _isLoading = false;
      });
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Thank you for your purchase',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            GestureDetector(
              child: const Text('close'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'Movies',
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return PageView.builder(
            controller: controller,
            itemCount: _titles.length,
            itemBuilder: (BuildContext context, int index) {
              final String title = _titles[index];
              final String image = _images[index];

              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                        child: const Text(
                          'Buy this movie',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
