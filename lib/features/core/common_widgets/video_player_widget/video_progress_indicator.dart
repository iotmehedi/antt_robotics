import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'full_screen_widget.dart';

class VideoProgressIndicatorWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullScreen;
  final int counter;
  final String videoUrl;

  const VideoProgressIndicatorWidget(
      {super.key,
        required this.controller,
        required this.isFullScreen,
        required this.counter,
        required this.videoUrl});

  @override
  _VideoProgressIndicatorWidgetState createState() => _VideoProgressIndicatorWidgetState();
}

class _VideoProgressIndicatorWidgetState extends State<VideoProgressIndicatorWidget> {
  late double _sliderValue;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      _sliderValue = 0.0;
    });
    // _sliderValue = widget.controller.value.position.inMilliseconds.toDouble();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          _sliderValue =
              widget.controller.value.position.inMilliseconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '${formatDuration(widget.controller.value.position)} / ${formatDuration(widget.controller.value.duration)}',
          ),
          Expanded(
            child: Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
                widget.controller.seekTo(Duration(milliseconds: value.toInt()));
              },
              min: 0.0,
              max: widget.controller.value.duration.inMilliseconds.toDouble(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            // onPressed: widget.onToggleFullScreen,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenVideoPlayer(
                      playbackPosition:
                      widget.controller.value.position.inSeconds.toDouble(),
                      videoUrl: widget.videoUrl),
                ),
              ).then((_) {
                setState(() {
                  widget.controller.pause();
                });
              });
            },
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}