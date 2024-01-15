import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Music {
  final String title;
  final String filePath;

  Music({
    required this.title,
    required this.filePath,
  });
}

Map<String, List<Music>> languageMusicMap = {
  'Chinese': [
    Music(title: '周杰倫 Jay Chou【夜曲 Nocturne】-Official Music Video.mp3', filePath: 'Chinese/Nocturne.mp3'),
    Music(title: '韋禮安-如果可以', filePath: 'Chinese/if.mp3'),
    Music(title: '田馥甄-小幸運', filePath: 'Chinese/smallLuck.mp3'),
  ],
  'Japanese': [
    Music(title: '米津玄師-灰色と青（+菅田将暉 ）', filePath: 'Japanese/Haiirotoao.mp3'),
    Music(title: '4', filePath: 'Japanese/4.mp3'),
    Music(title: 'finale', filePath: 'Japanese/finale.mp3'),
    Music(title: 'レミオロメン-粉雪', filePath: 'Japanese/konayuki.mp3'),


  ],
  'English': [
    Music(title: 'Never Gonna Give You Up', filePath: 'English/Nevergiveyouup.mp3'),
    Music(title: 'Flo Rida - Whistle [Official Video]', filePath: 'English/Whistle.mp3'),
  ],
};

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
    Timer(Duration(seconds: 3), () {
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


void _navigateToMusicPlayer(BuildContext context, String mp3Files) {
  Navigator.push(
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
                String mp3Files = "English";
                _navigateToMusicPlayer(context, mp3Files);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // 調整padding大小
                backgroundColor: Colors.greenAccent,
              ),
              child: Text('English',style: TextStyle(fontSize: 20),),
            ),
            ElevatedButton(
              onPressed: () async {
                String mp3Files = "Chinese";
                _navigateToMusicPlayer(context, mp3Files);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // 調整padding大小
                backgroundColor: Colors.orangeAccent,
              ),
              child: Text('中 文',style: TextStyle(fontSize: 20),),
            ),
            ElevatedButton(
              onPressed: () async {
                String mp3Files = "Japanese";
                _navigateToMusicPlayer(context, mp3Files);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20), // 調整padding大小
                backgroundColor: Colors.greenAccent,
              ),
              child: Text('日本語',style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}


class MusicPlayerScreen extends StatefulWidget {
  final String mp3Files;
  MusicPlayerScreen(this.mp3Files);
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}




class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  // ..setReleaseMode(ReleaseMode.loop);
  bool isPlaying = true;
  int currentIndex = 0;
  String image_name='images/p1.jpg';

  @override
  void initState() {
    super.initState();
    print('mp3Files: ${widget.mp3Files}');

    _loadMusic();

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        _next();
      }
    });
  }

  void _loadMusic() async {
    await _audioPlayer.stop();

    if (widget.mp3Files.isNotEmpty && currentIndex >= 0 &&
        currentIndex < widget.mp3Files.length) {
      await _audioPlayer.play(AssetSource(languageMusicMap[widget.mp3Files]
          ?.elementAt(currentIndex)
          .filePath ?? ''));

    } else {
      print('Invalid mp3Files or currentIndex');
    }
  }


  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
      image_name='images/p2.jpg';
    } else {
      image_name='images/p1.jpg';
      if (currentIndex >= 0 &&
          currentIndex < (languageMusicMap[widget.mp3Files]?.length ?? 0)) {
        _audioPlayer.play(AssetSource(languageMusicMap[widget.mp3Files]
            ?.elementAt(currentIndex)
            .filePath ?? ''));
      } else {
        print('Invalid currentIndex: $currentIndex');
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _next() {
    if (currentIndex < (languageMusicMap[widget.mp3Files]?.length ?? 1) - 1) {
      currentIndex++;
    } else {
      currentIndex = 0;
    }


    setState(() {
      isPlaying = true;
    });

    _loadMusic();
  }

  void _previous() {
    if (currentIndex > 0) {
      currentIndex--;
    } else {
      currentIndex = (languageMusicMap[widget.mp3Files]?.length ?? 1) - 1;
    }


    setState(() {
      isPlaying = true;
    });

    _loadMusic();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            // Spacer(), // 彈簧
            Padding(
              padding: EdgeInsets.only(left: 80.0), // 調整邊距
              child: Text('音樂播放器'),
            ),
            // Spacer(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              color: Colors.black12,
              child: Image.asset(image_name),
              height: 500,
              width: 500,
            ),
            Text(
              'Song Title: ${languageMusicMap[widget.mp3Files]?.elementAt(currentIndex).title}',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: _previous,
                ),
                IconButton(
                  icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: _next,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
