import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../features/course_details_play/course_details_play_tutorial.dart';
class FullScreenVideoPlayer extends StatefulWidget {
  final double? playbackPosition;
  final String videoUrl;

  const FullScreenVideoPlayer(
      {Key? key, this.playbackPosition, required this.videoUrl})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (widget.playbackPosition != null) {
          _controller
              .seekTo(Duration(seconds: widget.playbackPosition!.toInt()));
        }
        setState(() {
          _controller.play();
          _sliderValue = _controller.value.position.inSeconds.toDouble();
        });

        _controller.addListener(() {
          setState(() {
            _sliderValue = _controller.value.position.inSeconds.toDouble();
          });
        });
      });

    // Set resize mode to stretch
    // _controller.setLooping(true);
    _controller.setVolume(1.0);
    // _controller.setResizeMode(VideoResizeMode.stretch);

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
    _controller.seekTo(Duration(seconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        });
        return true;
      },
      child: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: _togglePlay,
                    icon: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black38.withOpacity(0.3)
                      ),
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _sliderValue,
                          onChanged: _onSliderChanged,
                          min: 0.0,
                          max: _controller.value.duration.inSeconds
                              .toDouble(),
                          divisions: _controller.value.duration.inSeconds,
                          label: _sliderValue.round().toString(),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            RouteGenerator.pushReplacementNamed(context, Routes.courseDetaiilsPage);
                            // Navigator.popUntil(context, (route) => route.isCurrent);

                            // Remove the previous page from the stack
                            // Navigator.pop(context);

                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                            //   return CourseDetailsPlayTutorial();
                            // }));
                            setState(() {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                            });
                          },
                          icon: Icon(Icons.fullscreen_exit))
                    ],
                  ),
                ),
              ],
            ),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        ),

      ),
    );
  }
}