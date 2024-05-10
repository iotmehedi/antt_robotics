import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/features/core/common_widgets/video_player_widget/video_controller.dart';
import 'package:interective_cares_task/features/features/course_details_play/course_details_play_tutorial.dart';
import 'package:interective_cares_task/features/features/signup_page/presentation/signup_page.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final List videoUrls;
  String singleUrl;
  int indexOfVideo;

  VideoPlayerScreen(
      {super.key,
      required this.singleUrl,
      required this.indexOfVideo,
      required this.videoUrls});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;
  bool _videoFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.singleUrl != ''
          ? widget.singleUrl
          : widget.videoUrls[widget.indexOfVideo].link,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      setState(() {
        Future.delayed(const Duration(seconds: 2), () {
          if (_controller.value.position == _controller.value.duration) {
            if (mounted) {
              ref.read(isFinish.notifier).state = widget.indexOfVideo + 1;
            }
          }
          _videoListener();
        });
      });
    });
    _controller.setLooping(false); // Set to true if you want the video to loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (_controller.value.position == _controller.value.duration) {
      if (!_videoFinished) {
        _videoFinished = true;
        updateFirstLink(widget.videoUrls[widget.indexOfVideo].id);
        _controller.pause();
      }
    } else {
      _videoFinished = false;
    }
  }

  Future<void> updateFirstLink(String documentId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('course_details').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('course_details')
            .doc(doc.id)
            .collection('video_url_list')
            .doc(documentId)
            .update({'isSeen': true}).then((_) {
          setState(() {
            if (ref
                .read(indexList.notifier)
                .state
                .contains(widget.indexOfVideo)) {
            } else {
              ref.read(indexList.notifier).state.add(widget.indexOfVideo);
            }

            ref.read(ddd.notifier).state = widget.indexOfVideo;
          });
        }).catchError((error) {});
      }
    } catch (e) {
      if (!context.mounted) return;
      snackbar(message: e.toString(), context: context, color: Colors.red);
    }
  }

  void playNextVideo() {
    if (widget.indexOfVideo < widget.videoUrls.length - 1) {
      setState(() {
        widget.singleUrl = '';
        widget.indexOfVideo++;
      });
      _controller = VideoPlayerController.network(
        widget.singleUrl != ''
            ? widget.singleUrl
            : widget.videoUrls[widget.indexOfVideo]['link'],
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void playPreviousVideo() {
    if (widget.indexOfVideo > 0) {
      setState(() {
        widget.singleUrl = '';
        widget.indexOfVideo--;
      });
      _controller = VideoPlayerController.network(
        widget.singleUrl != ''
            ? widget.singleUrl
            : widget.videoUrls[widget.indexOfVideo]['link'],
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio:
                      _isFullScreen ? _controller.value.aspectRatio : 16 / 9,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          VideoControls(
              controller: _controller,
              onSkipNext: playNextVideo,
              onSkipPrevious: playPreviousVideo,
              isFullScreen: _isFullScreen,
              counter: widget.indexOfVideo,
              videoUrl: widget.videoUrls[widget.indexOfVideo].link),
        ],
      ),
    );
  }
}
