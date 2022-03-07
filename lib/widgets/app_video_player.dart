import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String link;
  const AppVideoPlayer({
    required this.link,
  });
  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;

  Duration _duration = Duration();
  bool _isInit = true;
  bool _isLoading = false;
  bool _isMuted = false;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    if (_isInit) {
      _isLoading = true;
      Future.delayed(Duration.zero, () {
        print('init');
        _controller = VideoPlayerController.network(widget.link)
          ..addListener(() {
            print(_isLoading);
            setState(() {});
          })
          ..setLooping(false)
          ..initialize().then((_) {
            _duration = _controller!.value.duration;
            setState(() {
              _isLoading = false;
            });
            _controller!.play();
            _isMuted = _controller!.value.volume == 0;
            _isPlaying = _controller!.value.isPlaying;
          });
      });
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _controller!.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  int _rotation = 0;

  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    _isMuted = _controller != null ? (_controller!.value.volume == 0) : false;
    _isPlaying = _controller != null ? _controller!.value.isPlaying : false;
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        if (isTapped) {
          Future.delayed(const Duration(seconds: 2)).then((value) {
            setState(() {
              isTapped = false;
            });
          });
        }
      },
      child: Scaffold(
        body: _controller != null && _controller!.value.isInitialized ||
                !_isLoading
            ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTapped = !isTapped;
                      });
                      if (isTapped) {
                        Future.delayed(const Duration(seconds: 2))
                            .then((value) {
                          setState(() {
                            isTapped = false;
                          });
                        });
                      }
                    },
                    onDoubleTap: () {
                      if (!_isPlaying) {
                        _controller!.play();
                      } else {
                        _controller!.pause();
                      }
                    },
                    child: Container(
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!)),
                      ),
                    ),
                  ),
                  !isTapped
                      ? const SizedBox()
                      : Positioned(
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        !_isPlaying
                                            ? _controller!.play()
                                            : _controller!.pause();
                                      },
                                      child: Icon(
                                        !_isPlaying
                                            ? Icons.play_arrow_rounded
                                            : Icons.pause,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _controller!,
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      //Do Something with the value.
                                      return Text(
                                        '${value.position.inMinutes}:${value.position.inSeconds.remainder(60)}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Theme(
                                      data: ThemeData(
                                          sliderTheme: SliderThemeData(
                                              overlayColor: Colors.transparent,
                                              thumbColor: Colors.white,
                                              activeTrackColor: Colors.white,
                                              inactiveTrackColor:
                                                  Colors.grey.shade800,
                                              trackHeight: 1.0,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 5.0))),
                                      child: Slider(
                                        max: _controller!
                                            .value.duration.inSeconds
                                            .toDouble(),
                                        min: 0,
                                        value: _controller!
                                            .value.position.inSeconds
                                            .toDouble(),
                                        onChanged: (value) {
                                          _controller!.seekTo(
                                              Duration(seconds: value.toInt()));
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_duration.inMinutes}:${_duration.inSeconds.remainder(60)}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _controller!
                                            .setVolume(_isMuted ? 1.0 : 0);
                                        setState(() {});
                                      },
                                      child: Icon(
                                        _isMuted
                                            ? Icons.volume_off
                                            : Icons.volume_up,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        if (_rotation == 1) {
                                          _rotation = 0;
                                          setState(() {});
                                          SystemChrome.setPreferredOrientations(
                                              [DeviceOrientation.portraitUp]);
                                        } else {
                                          _rotation = 1;
                                          setState(() {});
                                          SystemChrome
                                              .setPreferredOrientations([
                                            DeviceOrientation.landscapeRight
                                          ]);
                                        }
                                      },
                                      icon: Icon(
                                        _rotation == 1
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          bottom: 0,
                          left: 0,
                          right: 0,
                        )
                ],
              )
            : Container(
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
