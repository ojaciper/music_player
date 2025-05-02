import 'package:flutter/material.dart';
import '../models/song.dart';
import '../core/services/music_api_service.dart';
import 'package:just_audio/just_audio.dart';

class HomeViewModel extends ChangeNotifier {
  final MusicApiService _apiService = MusicApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  List<Song> _songs = [];
  bool _isLoading = false;
  String? _error;

  set setIndex(int index) {
    _currentIndex = index;
  }

  int get index => _currentIndex;
  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSongs(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _songs = await _apiService.fetchSongs(query);
      _error = _songs.isEmpty ? 'No songs found for "$query"' : null;
    } catch (e) {
      _error =
          'Unable to fetch songs. Please check your internet connection and try again.';
      _songs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
