class MusicModel {
  late String description;
  late String artist;
  late String url;
  late String urlImage;
  late String albumArt;
  late int duration;
  late bool isLoading;
  late bool isPlaying;

  MusicModel(
      {required this.description,
      required this.url,
      required this.artist,
      required this.urlImage,
      required this.isLoading,
      required this.isPlaying});

  MusicModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    artist = json['artist'];
    url = json['url'];
    urlImage = json['urlImage'];
    albumArt = json['album_art'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['artist'] = this.artist;
    data['url'] = this.url;
    data['urlImage'] = this.urlImage;
    data['album_art'] = this.albumArt;
    return data;
  }
}
