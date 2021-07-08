import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';

class MusicController extends GetxController {
  RxList allMusic = <MusicModel>[].obs;

  var loadMusic = false.obs;

  @override
  void onInit() {
    _getAllMusic();
    super.onInit();
  }

  void _getAllMusic() {
    FirebaseFirestore.instance
        .collection('all_music')
        .snapshots()
        .listen((event) {
          loadMusic.value = false;
      allMusic.clear();
      event.docs.forEach((element) async {

        MusicModel model = MusicModel.fromJson(element.data());

        allMusic.add(model);
      });

      allMusic.sort((a, b) => a.description.compareTo(b.description));
      allMusic.refresh();
      loadMusic.value = true;
    });
  }


}
