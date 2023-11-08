import 'dart:async';
import 'package:fieldforce/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/desktop.mp4');

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _controller.play();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const MyHomePage(
                title: "Field Force",
              ),
              type: PageTransitionType.fade));
    });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, toolbarHeight: 0),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 180),
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return const Center();
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Evolving towards a",
                      style: TextStyle(
                          fontFamily: "Satoshi-Bold",
                          fontSize: 24,
                          color: Color.fromRGBO(0, 40, 144, 1)),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "power revolution",
                      style: TextStyle(
                          fontFamily: "Satoshi-Bold",
                          fontSize: 24,
                          color: Color.fromRGBO(0, 40, 144, 1)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: SizedBox(
                  width: 240,
                  height: 60,
                  child: SvgPicture.asset("assets/images/polaris-name.svg")),
            )),
          ],
        ),
      ),
    );
  }
}
