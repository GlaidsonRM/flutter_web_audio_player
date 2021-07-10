import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class MetaDataController extends GetxController {
  MusicController musicController = Get.find();

  @override
  void onInit() {
    musicController.loadMusic.listen((v) async {
      if (v) {
        MetadataRetriever retriever = MetadataRetriever();

        await Future.forEach(musicController.allMusic, (element) async {
          element as MusicModel;

          if(element.albumArt == ''){
            retriever = await getMetaData(element.url);
            await Future.delayed(Duration(seconds: 2));
            String img64 = base64Encode(retriever.albumArt!);
            await Future.delayed(Duration(seconds: 2));

            QuerySnapshot item = await FirebaseFirestore.instance
                .collection('all_music')
                .where('url', isEqualTo: element.url).get();

            item.docs.first.id;

            element.albumArt = img64;
            FirebaseFirestore.instance.collection('all_music').doc(item.docs.first.id).set(element.toJson());
            // element.albumArt = retriever.albumArt!;
            print('ImageLoaded: ${element.description}');
            print(img64);

            await Future.delayed(Duration(seconds: 10));
          }
        });
      }
    });

    super.onInit();
  }

  Future<MetadataRetriever> getMetaData(String url) async {
    MetadataRetriever retriever = MetadataRetriever();

    await retriever.setUri(Uri.parse(url));
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

  // Image imageFromBase64String(String base64String) {
  //   return Image.memory(base64Decode(base64String));
  // }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
