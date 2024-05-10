import 'package:flutter/material.dart';
import 'package:interective_cares_task/features/core/common_widgets/video_player_widget/video_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onSkipNext;
  final VoidCallback onSkipPrevious;

  final bool isFullScreen;
  final int counter;
  final String videoUrl;

  const VideoControls({
    required this.controller,
    required this.onSkipNext,
    required this.onSkipPrevious,
    required this.isFullScreen,
    required this.counter,
    required this.videoUrl,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: widget.onSkipPrevious,
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10_outlined),
                  onPressed: () {
                    widget.controller.seekTo(widget.controller.value.position -
                        const Duration(seconds: 10));
                  },
                ),
                IconButton(
                    icon: Icon(widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        if (widget.controller.value.isPlaying) {
                          widget.controller.pause();
                        } else {
                          widget.controller.play();
                        }
                      });
                    }),
                IconButton(
                  icon: const Icon(Icons.forward_10_outlined),
                  onPressed: () {
                    widget.controller.seekTo(widget.controller.value.position +
                        const Duration(seconds: 10));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_sharp),
                  onPressed: widget.onSkipNext,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: VideoProgressIndicatorWidget(
            controller: widget.controller,
            isFullScreen: widget.isFullScreen,
            counter: widget.counter,
            videoUrl: widget.videoUrl,
          ),
        ),
      ],
    );
  }
}