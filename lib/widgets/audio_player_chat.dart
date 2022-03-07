import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_message.dart';

class AudioPlayerSection extends StatefulWidget {
  final String link;
  final bool isLocale;

  const AudioPlayerSection({required this.link, this.isLocale = false});

  @override
  _AudioPlayerSectionState createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration();
  Duration _duration = Duration();
  bool _isPlaying = false;

  play(String link) async {
    if (_audioPlayer.state == PlayerState.STOPPED) {
      _audioPlayer.play(
        link,
        isLocal: widget.isLocale,
      );
      _isPlaying = true;
      setState(() {});
    } else if (_audioPlayer.state == PlayerState.PAUSED) {
      _audioPlayer.resume();
      _isPlaying = true;
      setState(() {});
    } else if (_audioPlayer.state == PlayerState.PLAYING) {
      _audioPlayer.pause();
      _isPlaying = false;
      setState(() {});
    } else {
      _audioPlayer.play(
        link,
      );
      _isPlaying = true;
      setState(() {});
    }
    _audioPlayer.onAudioPositionChanged.listen((event) {
      _position = event;
      setState(() {});
    });
    _audioPlayer.onDurationChanged.listen((event) {
      _duration = event;
      setState(() {});
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMessage(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              play(widget.link);
            },
            child: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 35,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5.0),
          Text(
            '${_position.inMinutes}:${_position.inSeconds.remainder(60)} / ${_duration.inMinutes}:${_duration.inSeconds.remainder(60)}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 0.55 * MediaQuery.of(context).size.width,
            child: Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.black87,
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
