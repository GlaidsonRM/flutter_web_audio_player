import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/features/google_drive_music/presentation/controller/google_drive_controller.dart';
import 'package:flutter_web_audio_player/features/metadata/presentation/controller/metadata_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:just_audio/just_audio.dart';

class GoogleDriveFilesPage extends StatelessWidget {
  final GoogleDriveController controller = GoogleDriveController();
  final MusicController musicController = Get.find();
  final MusicPlayerController playerController = Get.find();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (controller.pagenTok != null) {
          controller.getFiles();
        }
      }
    });

    controller.onInit();

    return WillPopScope(
      onWillPop: () async {
        if (controller.folderId.length > 1) {
          controller.folderId.removeLast();
          controller.pagenTok = null;
          controller.getFiles();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meu Google Drive'),
          centerTitle: true,
        ),
        body: Obx(() => controller.loading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: controller.loadingForPageToken.value
                          ? NeverScrollableScrollPhysics()
                          : AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: controller.filesList.length,
                      itemBuilder: (context, i) {
                        File file = controller.filesList[i];

                        String mimeType =
                            controller.getMimeType(file.mimeType ?? '');

                        return ListTile(
                          leading: mimeType == 'folder'
                              ? Icon(
                                  Icons.folder,
                                  color: Colors.amber,
                                )
                              : Icon(
                                  Icons.headset,
                                  color: Colors.green,
                                ),
                          title: Text(file.name ?? 'Sem Nome'),
                          onTap: () {
                            if (mimeType == 'folder') {
                              controller.folderId.add(file.id ?? 'root');
                              controller.filesList.clear();
                              controller.getFiles();
                            } else if (mimeType == 'audio') {
                              Get.defaultDialog(
                                  title: 'Adiconar',
                                  middleText:
                                      'Adicionar essa faixa a playlist?',
                                  textConfirm: 'Sim',
                                  textCancel: 'Não',
                                  onConfirm: () async {
                                    addMusic(file);
                                  });
                            }
                          },
                          trailing: mimeType == 'audio'
                              ? IconButton(
                                  icon: Icon(Icons.playlist_add),
                                  onPressed: () {
                                    addMusic(file);
                                  },
                                )
                              : Container(
                                  width: 1,
                                ),
                        );
                      },
                    ),
                  ),
                  controller.loadingForPageToken.value
                      ? Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                )
                              ],
                            )
                          ],
                        )
                      : Container()
                ],
              )),
      ),
    );
  }

  void addMusic(file) async {
    playerController.playList.children
        .add(AudioSource.uri(Uri.parse(file.webContentLink!)));

    // playerController.playList.children.insert(playerController.musicController.allMusic.length,
    //     AudioSource.uri(Uri.parse(file.webContentLink ?? 'No Link')));

    var base64 = await MetaDataController.getAlbumArt(file.webContentLink);

    musicController.allMusic.add(
      MusicModel(
          description: file.name!.split('.').first,
          url: file.webContentLink!,
          artist: file.name!.split('-').first,
          albumArt: base64,
          isLoading: false,
          isPlaying: false),
    );

    List<AudioSource> source = [];

    musicController.allMusic.forEach((element) {
      source.add(AudioSource.uri(Uri.parse(element.url)));
    });

    playerController.player.setAudioSource(
      playerController.playList,
    );

    Get.back();
  }
}
