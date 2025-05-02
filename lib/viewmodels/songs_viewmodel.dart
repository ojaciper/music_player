// State notifiers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/core/services/music_api_service.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  final MusicApiService _apiService;
  SongsNotifier(this._apiService) : super([]);

  Future<void> fetchSongs(String query) async {
    state = await _apiService.fetchSongs(query);
  }
}
