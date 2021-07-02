import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_audio_player/model/music_model.dart';

class InsertMusicPage extends StatelessWidget {
  final descriptionController = TextEditingController();
  final urlController = TextEditingController();
  final urlImagemController = TextEditingController();
  final artistController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insert Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Music'),
        ),
        body: Center(
          child: Container(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Descrição',
                        hintText: 'Digite a descrição'),
                    controller: descriptionController,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Artista',
                        hintText: 'Digite o Artista'),
                    controller: artistController,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Url',
                        hintText: 'Digite a url'),
                    controller: urlController,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Url Imagem',
                        hintText: 'Digite a url da imagem'),
                    controller: urlImagemController,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (descriptionController.text.isNotEmpty &&
                          urlController.text.isNotEmpty) {

                        MusicModel musicModel = MusicModel(
                        description: descriptionController.text,
                        url: urlController.text,
                        artist: artistController.text,
                        urlImage: urlImagemController.text, isPlaying: false, isLoading: false);

                        FirebaseFirestore.instance
                            .collection('all_music')
                            .doc()
                            .set(musicModel.toJson());

                        descriptionController.text = '';
                        urlController.text = '';
                        urlImagemController.text = '';
                        artistController.text = '';
                      }
                    },
                    child: Text('Inserir'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('all_music')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List itens = [];

                          snapshot.data.docs.forEach((element) {
                            MusicModel model = MusicModel.fromJson(element.data());
                            itens.add(model);
                          });

                          itens.sort((a, b) => a.description.compareTo(b.description));

                          return ListView.builder(
                            itemCount: itens.length,
                            itemBuilder: (context, index) {

                              MusicModel model = itens[index];

                              return ListTile(
                                title: Text(model.description),
                                subtitle: Text(model.url),
                              );
                            },
                          );
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
