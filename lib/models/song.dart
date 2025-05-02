class Song {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final String previewUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.previewUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'],
      artist: json['artist']['name'],
      albumArt: json['album']['cover_big'],
      previewUrl: json['preview'],
    );
  }
}
