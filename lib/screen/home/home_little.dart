import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class HomeLittle extends StatelessWidget {
  final MusicController musicController = Get.find();

  final MusicPlayerController playerController;
  HomeLittle(this.playerController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: 350, child: playerAudio()),
          Expanded(child: listMusic())
        ],
      ),
    );
  }

  listMusic() {
    return Obx(() => ListView.builder(
          itemCount: musicController.allMusic.length,
          itemBuilder: (context, index) {
            MusicModel musicModel = musicController.allMusic[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    playerController.isPaused.value = false;
                    playerController.playing.value = false;
                    playerController.positionMusicPlayer.value = index;
                    //playerController.playPauseMusic();
                  },
                  leading: Container(
                      height: 50,
                      width: 50,
                      child: Image.network(musicModel.urlImage)),
                  title: Text(musicModel.description),
                  subtitle: Text(musicModel.artist),
                  trailing: Text('03:12'),
                ),
                Divider(
                  thickness: 1,
                )
              ],
            );
          },
        ));
  }

  playerAudio() {
    return Obx(() => Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 8,
                      child: Center(
                        child: playerController.currentMusic.value.description ==
                                'Nada tocando'
                            ? Icon(
                                Icons.music_off,
                                size: 100,
                              )
                            : Image.network(
                                playerController.currentMusic.value.urlImage),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  playerController.loadingSong.value
                      ? CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : Column(
                          children: [
                            Text(
                              playerController.currentMusic.value.description,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              playerController.currentMusic.value.artist,
                              style: TextStyle(color: Colors.green, fontSize: 15),
                            )
                          ],
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          playerController.isPaused.value = false;
                          playerController.playing.value = false;
                          if (playerController.positionMusicPlayer.value == 0) {
                            playerController.positionMusicPlayer.value =
                                musicController.allMusic.length - 1;
                          } else {
                            playerController.positionMusicPlayer.value--;
                          }
                          //playerController.playPauseMusic();
                        },
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: playerController.newPlayer,
                        child: Icon(
                          playerController.playing.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          playerController.isPaused.value = false;
                          playerController.playing.value = false;
                          if (playerController.positionMusicPlayer.value ==
                              musicController.allMusic.length - 1) {
                            playerController.positionMusicPlayer.value = 0;
                          } else {
                            playerController.positionMusicPlayer.value++;
                          }
                          //playerController.playPauseMusic();
                        },
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 250,
                    child: SliderTheme(data: SliderThemeData(
                      trackHeight: 0.1,
                      showValueIndicator: ShowValueIndicator.never,
                      valueIndicatorColor: Colors.grey,
                      valueIndicatorShape: SliderComponentShape.noOverlay,
                      thumbColor: Colors.green,
                    ), child: Slider(onChanged: (double value) {
                      playerController.player.setVolume(value);

                      playerController.player.icyMetadataStream.listen((event) {
                        print(event!.info!.title);
                      });
                    }, value: playerController.player.volume,)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Slider(
                    value: playerController.positionMusic.value,
                    onChanged: (v) {
                      playerController.player
                          .seek(Duration(milliseconds: v.toInt()));
                    },
                    min: 0,
                    max: playerController.maxPositionMusic.value,
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          playerController.currentTimeMusic.value,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          playerController.maxTimeMusic.value,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<String> _getImage(String image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('album_images')
          .child('$image.png');
      var url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return '';
    }
  }
}
