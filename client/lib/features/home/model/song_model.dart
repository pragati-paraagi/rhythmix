// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SongModel {
  final String artist;
  final String id;
  final String thumbnailUrl;
  final String songUrl;
  final String songName;
  final String hexColor;

  SongModel({
    required this.artist,
    required this.id,
    required this.thumbnailUrl,
    required this.songUrl,
    required this.songName,
    required this.hexColor,
  });

  SongModel copyWith({
    String? artist,
    String? id,
    String? thumbnailUrl,
    String? songUrl,
    String? songName,
    String? hexColor,
  }) {
    return SongModel(
      artist: artist ?? this.artist,
      id: id ?? this.id,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      songUrl: songUrl ?? this.songUrl,
      songName: songName ?? this.songName,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artist': artist,
      'id': id,
      'thumbnail_url': thumbnailUrl,
      'song_url': songUrl,
      'song_name': songName,
      'hex_color': hexColor,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      artist: map['artist'] ?? '',
      id: map['id'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
      songUrl: map['song_url'] ?? '',
      songName: map['song_name'] ?? '',
      hexColor: map['hex_color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(artist: $artist, id: $id, thumbnailUrl: $thumbnailUrl, songUrl: $songUrl, songName: $songName, hexColor: $hexColor)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.artist == artist &&
        other.id == id &&
        other.thumbnailUrl == thumbnailUrl &&
        other.songUrl == songUrl &&
        other.songName == songName &&
        other.hexColor == hexColor;
  }

  @override
  int get hashCode {
    return artist.hashCode ^
        id.hashCode ^
        thumbnailUrl.hashCode ^
        songUrl.hashCode ^
        songName.hashCode ^
        hexColor.hashCode;
  }
}
