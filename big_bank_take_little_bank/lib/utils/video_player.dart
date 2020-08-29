// ignore: implementation_imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
  
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef DoubleClickAnimationListener = void Function();

class VideoViewer extends StatefulWidget {
  const VideoViewer({
    this.index,
    this.pics,
    this.list,
  });
  final int index;
  final List<String> pics;
  final List<String> list;
  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> with TickerProviderStateMixin {

  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      print(_videoPlayerController.value.aspectRatio);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        allowFullScreen: false,
        fullScreenByDefault: false,
        looping: true, 
        aspectRatio: _videoPlayerController.value.aspectRatio,
        // Try playing around with some of these other options:

        // showControls: false,
        // materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        //   bufferedColor: Colors.lightGreen,
        // ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        // autoInitialize: true,
      );
    });
  }

  @override
  void initState() {
    String url = widget.list[widget.index];
    if (url.contains('video') || url.split('.').last == 'm3u8') {
      print(url);
      _videoPlayerController = VideoPlayerController.network(url);
    }
    _future = initVideoPlayer();

    super.initState();
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    if (_chewieController != null) {
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.list[widget.index];
    if (url.contains('video') || url.split('.').last == 'm3u8') {
      Widget result = Material(
        color: Colors.black,
        child: Center(
          child: _videoPlayerController.value.initialized
          ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          )
          : new CircularProgressIndicator(),
        ),
      );

      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              result,
              IconButton(
                icon: Icon(Icons.close, color: Colors.white,size: 36,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
