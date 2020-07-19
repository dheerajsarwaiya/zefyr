import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeLocalPlayer extends StatefulWidget {
  final String videoID;
  

  const YoutubeLocalPlayer({Key key, this.videoID}) : super(key: key);

  @override
  _YoutubeLocalPlayerState createState() => _YoutubeLocalPlayerState();
}

class _YoutubeLocalPlayerState extends State<YoutubeLocalPlayer> {
  YoutubePlayerController _controller;
  // bool _isDisposed = false;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID,
      params: const YoutubePlayerParams(
        autoPlay: true,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('am i coming here111111111111');
    // if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (UniversalPlatform.isWeb && constraints.maxWidth > 800) {
            return YoutubePlayerIFrame();
          } else {
            return YoutubePlayerIFrame();
          }
        },
      ),
    );
    // } else {
    //       return GestureDetector(
    //   child: Stack(
    //     children: <Widget>[
    //       // Icon(Icons.play_arrow),

    //       Container(
    //         height: MediaQuery.of(context).size.width > 800
    //             ? 450
    //             : MediaQuery.of(context).size.width * 9 / 16,
    //         width: MediaQuery.of(context).size.width > 800
    //             ? 800
    //             : MediaQuery.of(context).size.width,
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: NetworkImage(
    //                 "https://img.youtube.com/vi/${widget.videoID}/hqdefault.jpg"),
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //           bottom: MediaQuery.of(context).size.width > 800
    //               ? 200
    //               : MediaQuery.of(context).size.width * 9 / 32,
    //           left: MediaQuery.of(context).size.width > 800
    //               ? 360
    //               : MediaQuery.of(context).size.width * 4.5 / 10,
    //           child: Image.asset(
    //             "assets/images/youtube.png",
    //             width: 64,
    //             height: 64,
    //           )),
    //     ],
    //   ),
    //   onTap: () async {
    //     var url = "https://www.youtube.com/watch?v=" + widget.videoID;

    //     if (await canLaunch(url)) {
    //       await launch(url, forceSafariVC: false);
    //     } else {
    //       print("unable to launch url");
    //       // throw 'Could not launch $url';
    //     }
    //   },
    // );
    // }
  }

  // @override
  // void deactivate() {
  //   super.deactivate();

  //   // _controller.pause();
  // }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

// @override
// Widget build(BuildContext context) {
//   // print("am i coming here");
//   if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
//     return YoutubePlayer(
//       width: MediaQuery.of(context).size.width * .9,
//       controller: _controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: Colors.amber,
//       // bufferIndicator: null,
//       progressColors: ProgressBarColors(
//         playedColor: Colors.amber,
//         handleColor: Colors.amberAccent,
//       ),
//       // thumbnail: Image.network("https://img.youtube.com/vi/${widget.videoID}/hqdefault.jpg"),

//       thumbnailUrl:
//           "https://img.youtube.com/vi/${widget.videoID}/hqdefault.jpg",
//       // onReady: () {
//       //   // _controller.;
//       //   print('Player is ready.');
//       //   // _controller.pause();
//       // },
//     );
//   } else {
//     return GestureDetector(
//       child: Stack(
//         children: <Widget>[
//           // Icon(Icons.play_arrow),

//           Container(
//             height: MediaQuery.of(context).size.width > 800
//                 ? 450
//                 : MediaQuery.of(context).size.width * 9 / 16,
//             width: MediaQuery.of(context).size.width > 800
//                 ? 800
//                 : MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(
//                     "https://img.youtube.com/vi/${widget.videoID}/hqdefault.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//               bottom: MediaQuery.of(context).size.width > 800
//                   ? 200
//                   : MediaQuery.of(context).size.width * 9 / 32,
//               left: MediaQuery.of(context).size.width > 800
//                   ? 360
//                   : MediaQuery.of(context).size.width * 4.5 / 10,
//               child: Image.asset(
//                 "assets/images/youtube.png",
//                 width: 64,
//                 height: 64,
//               )),
//         ],
//       ),
//       onTap: () async {
//         var url = "https://www.youtube.com/watch?v=" + widget.videoID;

//         if (await canLaunch(url)) {
//           await launch(url, forceSafariVC: false);
//         } else {
//           print("unable to launch url");
//           // throw 'Could not launch $url';
//         }
//       },
//     );
//   }
// }

// class Controls extends StatelessWidget {
//   const Controls();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           PlayPauseButtonBar(),
//           _space,
//           VolumeSlider(),
//         ],
//       ),
//     );
//   }

//   Widget get _space => const SizedBox(height: 10);
// }
