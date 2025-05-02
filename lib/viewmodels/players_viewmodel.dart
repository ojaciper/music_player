import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:music_player/models/song.dart';
import 'package:music_player/providers/states/player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  final AudioPlayer _player;
  PlayerNotifier(this._player) : super(PlayerState()) {
    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (state.isRepeatOn) {
          if (state.currentIndex < state.playlist.length - 1) {
            next();
          } else {
            state = state.copyWith(currentIndex: 0);
            playCurrent();
          }
        } else {
          if (state.currentIndex < state.playlist.length - 1) {
            next();
          } else {
            state = state.copyWith(isCompleted: true);
            _player.stop();
          }
        }
      }
      // Update loading state based on processing state
      state = state.copyWith(
        isLoading: playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      );
    });

    // Listen to position updates
    _player.positionStream.listen((position) {
      state = state.copyWith(currentPosition: position);
    });

    // Listen to duration updates
    _player.durationStream.listen((duration) {
      state = state.copyWith(duration: duration ?? Duration.zero);
    });
  }

  Duration get position => state.currentPosition;
  Duration get duration => state.duration;
  bool get isPlaying => _player.playing;

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(currentPosition: position);
  }

  Future<void> seekByOffset(double seconds) async {
    final newPosition =
        state.currentPosition + Duration(seconds: seconds.round());
    await seekTo(newPosition);
  }

  void setPlaylist(List<Song> songs, {int startIndex = 0}) {
    state = state.copyWith(
      playlist: songs,
      originalPlaylist: songs,
      currentIndex: startIndex,
      isCompleted: false,
    );
    playCurrent();
  }

  Future<void> playCurrent() async {
    if (state.playlist.isEmpty) return;
    try {
      state = state.copyWith(isLoading: true, isCompleted: false);
      await _player.setUrl(state.currentSong!.previewUrl);
      await _player.play();
    } catch (e) {
      print('Error playing song: $e');
      state = state.copyWith(isLoading: false);
      if (state.currentIndex < state.playlist.length - 1) {
        next();
      }
    }
  }

  void toggleRepeat() {
    state = state.copyWith(isRepeatOn: !state.isRepeatOn);
    if (state.isRepeatOn && state.isCompleted) {
      state = state.copyWith(currentIndex: 0);
      playCurrent();
    }
  }

  void toggleShuffle() {
    final isShuffled = !state.isShuffled;
    if (isShuffled) {
      final currentSong = state.currentSong;
      final shuffledList = List<Song>.from(state.playlist)..shuffle();
      shuffledList.remove(currentSong);
      shuffledList.insert(0, currentSong!);
      state = state.copyWith(
        playlist: shuffledList,
        isShuffled: true,
        currentIndex: 0,
      );
    } else {
      final currentSong = state.currentSong;
      final index = state.originalPlaylist.indexOf(currentSong!);
      state = state.copyWith(
        playlist: state.originalPlaylist,
        isShuffled: false,
        currentIndex: index,
      );
    }
  }

  void next() {
    if (state.playlist.isEmpty) return;
    if (state.currentIndex < state.playlist.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      playCurrent();
    } else if (state.isRepeatOn) {
      state = state.copyWith(currentIndex: 0);
      playCurrent();
    }
  }

  void previous() {
    if (state.playlist.isEmpty) return;
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
      playCurrent();
    } else if (state.isRepeatOn) {
      state = state.copyWith(currentIndex: state.playlist.length - 1);
      playCurrent();
    }
  }

  void playPause() {
    if (state.isCompleted) {
      playCurrent();
    } else if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
