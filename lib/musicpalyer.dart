// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  List<FileSystemEntity> arrSongs = [];
  final _player = AudioPlayer();
  bool isPlaying = false;
  String currentPlaying = "";

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
    Directory dir = Directory('/storage/emulated/0/Music');
    String mp3path = dir.toString();
    List<FileSystemEntity> _files;
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) arrSongs.add(entity);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note,color: Colors.grey[300],),
            Text(
              'Music Player',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[300],),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          currentPlaying.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: PhysicalModel(
                      elevation: 8,
                      color: Colors.teal.shade800,
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                '${currentPlaying}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 0.5),
                              )),
                          Slider(
                            activeColor: Colors.teal,
                            thumbColor: Colors.teal[300],
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final seekPosition =
                                  Duration(seconds: value.toInt());
                              await _player.seek(seekPosition);
                            },
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatTime(position),
                                  style: TextStyle(color: Colors.tealAccent),
                                ),
                                IconButton(
                                    color: Colors.white,
                                    disabledColor: Colors.teal,
                                    iconSize: 48,
                                    onPressed: () {
                                      if (isPlaying) {
                                        _player.pause();
                                        isPlaying = false;
                                      } else {
                                        _player.play();
                                        isPlaying = true;
                                      }
                                      setState(() {});
                                    },
                                    icon: isPlaying
                                        ? Icon(
                                            Icons.pause_circle_outline_outlined)
                                        : Icon(
                                            Icons.play_circle_fill_outlined)),
                                Text(
                                  formatTime(duration),
                                  style: TextStyle(color: Colors.tealAccent),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ),
          SizedBox(
            height: 30,
            child: Text(
              "PlayList",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return _display(arrSongs[index]);
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: arrSongs.length))
        ],
      ),
    );
  }

  void playerAction(FileSystemEntity file) async {
    // Ensure player is stopped before loading new song
    await _player.stop();
    await _player.setUrl(file.path);

    _player.positionStream.listen((event) {
      Duration temp = event as Duration;
      position = temp;
      setState(() {});
    });

    if (_player.duration != null) {
      duration = _player.duration!;
    }

    if (currentPlaying == file) {
      if (isPlaying) {
        _player.pause();
        isPlaying = false;
      } else {
        _player.play();
        isPlaying = true;
      }
    } else {
      isPlaying = true;
      _player.play();
    }
    currentPlaying = File(file.path).uri.pathSegments.last;
    setState(() {});
  }

  _display(FileSystemEntity file) {
    String fileName = File(file.path).uri.pathSegments.last;
    return InkWell(
      onTap: () => playerAction(file),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(
          "${fileName}",
          style: TextStyle(fontSize: 18, color: Colors.teal[900]),
        ),
      ),
    );
  }
}

String formatTime(Duration value) {
  String twoDigit(int n) => n.toString().padLeft(2, '0');
  final hour = twoDigit(value.inHours);
  final min = twoDigit(value.inMinutes.remainder(60));
  final sec = twoDigit(value.inSeconds.remainder(60));
  return [if (value.inHours > 0) hour, min, sec].join(":");
}
