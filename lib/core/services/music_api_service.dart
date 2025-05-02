import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/song.dart';

class MusicApiService {
  Future<List<Song>> fetchSongs(String query) async {
    final url = 'https://api.deezer.com/search?q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }
}
