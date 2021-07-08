import 'dart:math';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class MetaDataController extends GetxController {
  MusicController musicController = Get.find();

  @override
  void onInit() {

    musicController.loadMusic.listen((v) async {
      if(v){
        MetadataRetriever retriever = MetadataRetriever();

        await Future.forEach(musicController.allMusic, (element) async {

            element as MusicModel;

            retriever = await getMetaData(element.url);

            element.albumArt = retriever.albumArt!;
            print('ImageLoaded: ${element.description}');

        });

      }
    });


    super.onInit();
  }

  Future<MetadataRetriever> getMetaData(String url) async {
    MetadataRetriever retriever = MetadataRetriever();

    await retriever.setUri(Uri.parse(
        url));
    // Metadata metadata = await retriever.metadata;
    //
    // metadata.trackName;
    // metadata.trackArtistNames;
    // metadata.albumName;
    // metadata.albumArtistName;
    // metadata.trackNumber;
    // metadata.albumLength;
    // metadata.year;
    // metadata.genre;
    // metadata.authorName;
    // metadata.writerName;
    // metadata.discNumber;
    // metadata.mimeType;
    // metadata.trackDuration;
    // metadata.bitrate;
    //
    // retriever.albumArt;

    return retriever;
  }
}