import 'dart:convert';
import 'package:http/http.dart';

Future<void> main() async {
  final Response response = await get(Uri.parse('https://yts.mx/api/v2/list_movies.json'));

  final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
  final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
  final List<Map<dynamic, dynamic>> movies = List<Map<dynamic, dynamic>>.from(data['movies'] as List<dynamic>);

  print(movies);
}

class MovieLoader {
  MovieLoader(this.title, this.image, this.year);


  late String title;
  late String image;
  late int year;
}
