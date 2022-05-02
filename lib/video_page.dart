import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: VideoApp(filePath: '',)));

class VideoApp extends StatefulWidget {
  final String filePath;

  const VideoApp({Key? key, required this.filePath}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;
  Duration? videoLength;
  Duration? videoPosition;
  double volume = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.filePath)
      ..addListener(() => setState(() {
        videoPosition = _controller!.value.position;
        debugPrint(widget.filePath);
      }))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {

          videoLength = _controller!.value.duration;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_controller!.value.isInitialized) ...[
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: true,
                  padding: const EdgeInsets.all(10),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () => setState(
                              () {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                          '${convertToMinutesSeconds(videoPosition!)} / ${convertToMinutesSeconds(videoLength!)}'),
                    ),
                    Expanded(child: Icon(animatedVolumeIcon(volume))),
                    Expanded(
                      child: Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          onChanged: (changedVolume) {
                            setState(() {
                              volume = changedVolume;
                              _controller!.setVolume(changedVolume);
                            });
                          }),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: Icon(Icons.loop,
                              color: _controller!.value.isLooping
                                  ? Colors.green
                                  : Colors.black),
                          onPressed: () {
                            _controller!.setLooping(!_controller!.value.isLooping);
                          }),
                    )
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

String convertToMinutesSeconds(Duration duration) {
  final parsedMinutes = duration.inMinutes % 60;

  final minutes =
  parsedMinutes < 10 ? '0$parsedMinutes' : parsedMinutes.toString();

  final parsedSeconds = duration.inSeconds % 60;

  final seconds =
  parsedSeconds < 10 ? '0$parsedSeconds' : parsedSeconds.toString();

  return '$minutes:$seconds';
}

IconData animatedVolumeIcon(double volume) {
  if (volume == 0) {
    return Icons.volume_mute;
  } else if (volume < 0.5) {
    return Icons.volume_down;
  } else {
    return Icons.volume_up;
  }
}