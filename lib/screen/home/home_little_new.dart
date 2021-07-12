import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/controller/audio_actions.dart';
import 'package:flutter_web_audio_player/controller/music_controller.dart';
import 'package:flutter_web_audio_player/controller/music_player_controller.dart';
import 'package:flutter_web_audio_player/screen/home/playlist_playing.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

class HomeLittleNew extends StatefulWidget {
  final MusicPlayerController playerController;

  HomeLittleNew(this.playerController);

  @override
  _HomeLittleNewState createState() => _HomeLittleNewState();
}

class _HomeLittleNewState extends State<HomeLittleNew> {
  final MusicController musicController = Get.find();

  final AudioActions actions = AudioActions();

  Color background = Colors.redAccent.shade100;

  @override
  Widget build(BuildContext context) {
    listenImageColor();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'PLAYLIST',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Loved tracks',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 35,
          ),
        ),
      ),
      body: Column(
        children: [
          Obx(() => Padding(
                padding: const EdgeInsets.all(16),
                child: widget.playerController.currentMusic.value == null ||
                        widget.playerController.currentMusic.value.albumArt ==
                            null
                    ? Icon(Icons.clear)
                    : Image.memory(base64Decode(
                        widget.playerController.currentMusic.value.albumArt!)),
              )),
          widget.playerController.loadingSong.value
              ? CircularProgressIndicator(
                  color: Colors.green,
                )
              : Obx(() => Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.playerController.currentTimeMusic.value,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.playerController.maxTimeMusic.value,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )),
          Obx(() => SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                minThumbSeparation: 0,
                trackHeight: 2,
                valueIndicatorColor: Colors.white,
                overlayColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
                activeTrackColor: Colors.white,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Column(
                children: [
                  Slider(
                    onChanged: (double value) {
                      widget.playerController.player
                          .seek(Duration(milliseconds: value.toInt()));
                    },
                    value: widget.playerController.positionMusic.value,
                    min: 0,
                    max: widget.playerController.maxPositionMusic.value,
                  ),
                ],
              ))),
          Obx(
            () => Text(
              widget.playerController.currentMusic.value.description!
                  .split('-')
                  .last,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Obx(() => Text(
                widget.playerController.currentMusic.value.description!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: actions.previousMusic,
                child: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: actions.playOrPause,
                child: Icon(
                  widget.playerController.player.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: actions.nextMusic,
                child: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.surround_sound,
                  color: Colors.white,
                  size: 30,
                ),
                InkWell(
                    onTap: () => Get.to(PlaylistPlaying(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 700)),
                    child: Icon(
                      Icons.playlist_play_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Color> getImagePalette(String imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            MemoryImage(base64Decode(imageProvider)));

    setState(() {
      background = paletteGenerator.darkMutedColor!.color;
    });

    return paletteGenerator.dominantColor!.color;
  }

  void listenImageColor() {
    widget.playerController.currentMusic.listen((value) {
      getImagePalette(value.albumArt!);
    });
  }
}
