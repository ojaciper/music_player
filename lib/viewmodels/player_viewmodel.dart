import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class PlayerViewModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  List<Song> _originalPlaylist = []; // Keep original order for shuffle
  int _currentIndex = 0;
  bool _isCompleted = false;
  bool _isShuffled = false;
  bool _isRepeatOn = false;
  Duration _currentPosition = Duration.zero;

  AudioPlayer get player => AudioPlayer();
  bool get isPlaying => _audioPlayer.playing;
  bool get isCompleted => _isCompleted;
  bool get isShuffled => _isShuffled;
  bool get isRepeatOn => _isRepeatOn;
  Duration get position => _currentPosition;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Song? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;

  PlayerViewModel() {
    _audioPlayer.playerStateStream.listen((_) => notifyListeners());
    // Listen to position changes more frequently
    _audioPlayer.positionStream.listen((pos) {
      _currentPosition = pos;
      notifyListeners();
    });

    // Listen for song completion
    _audioPlayer.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        if (_isRepeatOn) {
          // If repeat is on, either replay current song or go to next
          if (_currentIndex < _playlist.length - 1) {
            next();
          } else {
            _currentIndex = 0;
            await playCurrent();
          }
        } else {
          if (_currentIndex < _playlist.length - 1) {
            next();
          } else {
            _isCompleted = true;
            await _audioPlayer.stop();
            notifyListeners();
          }
        }
      }
    });
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    // If we're at the end and turning repeat on, restart playlist
    if (_isRepeatOn && _isCompleted) {
      _currentIndex = 0;
      playCurrent();
    }
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      // Save original playlist if not saved
      if (_originalPlaylist.isEmpty) {
        _originalPlaylist = List.from(_playlist);
      }
      // Shuffle playlist except current song
      final currentSong = _playlist[_currentIndex];
      _playlist.removeAt(_currentIndex);
      _playlist.shuffle();
      _playlist.insert(0, currentSong);
      _currentIndex = 0;
    } else {
      // Restore original playlist order
      final currentSong = _playlist[_currentIndex];
      _playlist = List.from(_originalPlaylist);
      _currentIndex = _playlist.indexOf(currentSong);
    }
    notifyListeners();
  }

  void setPlaylist(List<Song> songs, {int startIndex = 0}) {
    _playlist = List.from(songs);
    _originalPlaylist = List.from(songs); // Save original order
    _currentIndex = startIndex;
    _isCompleted = false;
    playCurrent();
  }

  Future<void> playCurrent() async {
    if (_playlist.isEmpty) return;
    _isCompleted = false;
    try {
      await _audioPlayer.setUrl(_playlist[_currentIndex].previewUrl);
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
      // If there's an error, try to play next song
      if (_currentIndex < _playlist.length - 1) {
        next();
      }
    }
  }

  void playPause() {
    if (_isCompleted) {
      // If completed, restart the song
      playCurrent();
    } else if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    notifyListeners();
  }

  // void rewind() {
  //   final newPosition = _audioPlayer.position - const Duration(seconds: 10);
  //   _audioPlayer
  //       .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  // }

  void next() {
    if (_playlist.isEmpty) return;
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else if (_isRepeatOn) {
      _currentIndex = 0;
    } else {
      return;
    }
    playCurrent();
  }

  void previous() {
    if (_playlist.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
    } else if (_isRepeatOn) {
      _currentIndex = _playlist.length - 1;
    } else {
      return;
    }
    playCurrent();
  }

  // Seek to specific position
  Future<void> seekTo(Duration position) async {
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    if (position > duration) {
      position = duration;
    }
    await _audioPlayer.seek(position);
    _currentPosition = position;
    notifyListeners();
  }

  // Seek by offset (positive or negative seconds)
  Future<void> seekByOffset(double seconds) async {
    final newPosition = _currentPosition + Duration(seconds: seconds.round());
    await seekTo(newPosition);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
