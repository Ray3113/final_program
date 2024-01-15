import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

Future<List<String>> _getMp3Files(String languageFolder) async {
  try {
    // 指定路径
    List<String> mp3Files = [];

    String file_path = Directory.current.path + languageFolder;
    Directory directory = Directory(file_path);

    // 查找所有MP3文件
    List<FileSystemEntity> fileList = directory.listSync(recursive: true);
    for (var file in fileList) {
      if (file is File && file.path.endsWith('.mp3')) {
        mp3Files.add(file.path);
      }
    }

    for (var mp3File in mp3Files) {
      print('MP3 File: ${mp3File}');
    }

    return mp3Files;

  } catch (e) {
    print('Error: $e');
    return Future.error('Failed to get MP3 files');
  }

}

// Future<List<String>> _getMp3Files(String languageFolder) async {
//   Directory directory = Directory('assets/$languageFolder/'); // 替換成你的音樂檔案所在的目錄
//   List<String> mp3Files = [];
//
//   try {
//     List<FileSystemEntity> files = directory.listSync();
//     for (FileSystemEntity file in files) {
//       if (file is File && file.path.endsWith('.mp3')) {
//         mp3Files.add(file.path);
//       }
//     }
//   } catch (e) {
//     print('Error reading mp3 files: $e');
//   }
//
//   return mp3Files;
// }

void _navigateToMusicPlayer(BuildContext context, List<String> mp3Files) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MusicPlayerScreen(mp3Files)),
  );
}

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                List<String> mp3Files = await _getMp3Files('English');
                _navigateToMusicPlayer(context, mp3Files);
              },
              child: Text('English'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<String> mp3Files = await _getMp3Files('Chinese');
                _navigateToMusicPlayer(context, mp3Files);
              },
              child: Text('中文'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<String> mp3Files = await _getMp3Files('Japanese');
                _navigateToMusicPlayer(context, mp3Files);
              },
              child: Text('日本語'),
            ),
          ],
        ),
      ),
    );
  }
}


class MusicPlayerScreen extends StatefulWidget {
  final List<String> mp3Files;
  MusicPlayerScreen(this.mp3Files);
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

// class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
//   AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   int currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMusic();
//   }
//
//   void _loadMusic() async {
//     await _audioPlayer.play(AssetSource(musicList[currentIndex].filePath));
//   }
//
//   void _playPause() {
//     if (isPlaying) {
//       _audioPlayer.pause();
//     } else {
//       _audioPlayer.play(AssetSource(musicList[currentIndex].filePath));
//     }
//
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }
//
//   void _stop() {
//     _audioPlayer.stop();
//     setState(() {
//       isPlaying = false;
//     });
//   }
//
//   void _next() {
//     if (currentIndex < musicList.length - 1) {
//       currentIndex++;
//       _loadMusic();
//       _playPause();
//     }
//   }
//
//   void _previous() {
//     if (currentIndex > 0) {
//       currentIndex--;
//       _loadMusic();
//       _playPause();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('音樂撥放器'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               color: Colors.lightBlueAccent,
//               child:Image.asset('images/f1.jpg'),
//               height: 500,
//               width: 500,
//             ),
//             Text(
//               musicList[currentIndex].title,
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               musicList[currentIndex].artist,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.skip_previous),
//                   onPressed: _previous,
//                 ),
//                 IconButton(
//                   icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
//                   onPressed: _playPause,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.stop),
//                   onPressed: _stop,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.skip_next),
//                   onPressed: _next,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    print('mp3Files: ${widget.mp3Files}');
    _loadMusic();
  }

  void _loadMusic() async {
    await _audioPlayer.stop();

    // Check if mp3Files is not empty and currentIndex is in a valid range
    if (widget.mp3Files.isNotEmpty && currentIndex >= 0 && currentIndex < widget.mp3Files.length) {
      await _audioPlayer.play(AssetSource(widget.mp3Files[currentIndex]));
    } else {
      print('Invalid mp3Files or currentIndex');
    }
  }



  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      // 檢查 currentIndex 是否在有效範圍內
      if (currentIndex >= 0 && currentIndex < widget.mp3Files.length) {
        _audioPlayer.play(AssetSource(widget.mp3Files[currentIndex]));
      } else {
        print('Invalid currentIndex: $currentIndex');
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Song Title: ${widget.mp3Files[currentIndex].split('/').last.replaceAll('.mp3', '')}',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}
