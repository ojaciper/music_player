import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:music_player/providers/states/loading_state.dart';
import 'package:music_player/providers/states/player_state.dart';
import 'package:music_player/viewmodels/loading_viewmodel.dart';
import 'package:music_player/viewmodels/players_viewmodel.dart';
import 'package:music_player/viewmodels/songs_viewmodel.dart';
import '../models/song.dart';
import '../core/services/music_api_service.dart';

// Services
final musicApiServiceProvider = Provider((ref) => MusicApiService());
final audioPlayerProvider = Provider((ref) => AudioPlayer());

// loadingstate Providers
final loadingStateProvider =
    StateNotifierProvider<LoadingStateNotifier, LoadingState>((ref) {
  return LoadingStateNotifier();
});

//songState Provider
final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>((ref) {
  final apiService = ref.watch(musicApiServiceProvider);
  return SongsNotifier(apiService);
});

// playerstateProvider
final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return PlayerNotifier(player);
});
