import 'package:flick_video_player/flick_video_player.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:pod_player/pod_player.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/utils/uiUtils.dart';
import 'package:news/utils/internetConnectivity.dart';
import 'package:news/ui/screens/NewsDetailsVideo.dart';
import 'package:news/data/models/LiveStreamingModel.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/data/models/BreakingNewsModel.dart';

class NewsVideo extends StatefulWidget {
  int from;
  LiveStreamingModel? liveModel;
  NewsModel? model;
  BreakingNewsModel? breakModel;

  NewsVideo({super.key, this.model, required this.from, this.liveModel, this.breakModel});

  @override
  State<StatefulWidget> createState() => StateVideo();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(builder: (_) => NewsVideo(from: arguments['from'], liveModel: arguments['liveModel'], model: arguments['model'], breakModel: arguments['breakModel']));
  }
}

class StateVideo extends State<NewsVideo> {
  FlickManager? flickManager;
  late final PodPlayerController podController;
  YoutubePlayerController? _yc;
  bool _isNetworkAvail = true;

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    checkNetwork();
    initialisePlayer();
  }

  initialisePlayer() {
    switch (widget.from) {
      case 1:
        if (widget.model!.contentValue != "" || widget.model!.contentValue != null) {
          if (widget.model!.contentType == "video_upload") {
            _controller = VideoPlayerController.networkUrl(Uri.parse(widget.model!.contentValue!));
            flickManager = FlickManager(videoPlayerController: _controller!, autoPlay: true);
          } else if (widget.model!.contentType == "video_youtube") {
            _yc = YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(widget.model!.contentValue!) ?? "", flags: const YoutubePlayerFlags(autoPlay: true));
          }
        }
        break;
      case 2:
        if (widget.liveModel!.type == "url_youtube") {
          _yc = YoutubePlayerController(initialVideoId: getIdFromUrl(widget.liveModel!.url!) ?? "", flags: const YoutubePlayerFlags(autoPlay: true, isLive: true));
        }
        break;
      default:
        if (widget.breakModel!.contentValue != "" || widget.breakModel!.contentValue != null) {
          if (widget.breakModel!.contentType == "video_upload") {
            _controller = VideoPlayerController.networkUrl(Uri.parse(widget.breakModel!.contentValue!));
            flickManager = FlickManager(videoPlayerController: _controller!, autoPlay: true);
          } else if (widget.breakModel!.contentType == "video_youtube") {
            _yc = YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(widget.breakModel!.contentValue!) ?? "", flags: const YoutubePlayerFlags(autoPlay: true));
          }
        }
    }
  }

  checkNetwork() async {
    if (await InternetConnectivity.isNetworkAvailable()) {
      setState(() => _isNetworkAvail = true);
    } else {
      setState(() => _isNetworkAvail = false);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    if (_controller != null && _controller!.value.isPlaying) _controller!.pause();
    switch (widget.from) {
      case 1:
        if (widget.model!.contentType == "video_upload") {
          Future.delayed(const Duration(milliseconds: 10)).then((value) {
            flickManager!.flickControlManager!.exitFullscreen();
            flickManager!.dispose();
            _controller!.dispose();
            _controller = null;
            flickManager = null;
          });
        } else if (widget.model!.contentType == "video_youtube") {
          _yc!.dispose();
        }
        break;
      case 2:
        if (widget.liveModel!.type == "url_youtube") {
          _yc!.dispose();
        }
        break;
      default:
        if (widget.breakModel!.contentType == "video_upload") {
          _controller = null;
          flickManager!.dispose();
        } else if (widget.breakModel!.contentType == "video_youtube") {
          _yc!.dispose();
        }
    }
    Future.delayed(const Duration(milliseconds: 20)).then((value) {
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, //to show Landscape video fullscreen
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                Navigator.of(context).pop();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(22.0),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: UiUtils.getColorScheme(context).primaryContainer, shape: BoxShape.circle),
                          child: Icon(Icons.keyboard_backspace_rounded, color: UiUtils.getColorScheme(context).surface)))),
            )),
        body: PopScope(
          canPop: true,
          onPopInvoked: (val) async {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
            if (widget.from == 1 && (widget.model!.contentType == "video_upload")) {
              _controller!.pause();

              Future.delayed(const Duration(milliseconds: 10)).then((value) {
                flickManager!.flickControlManager!.exitFullscreen();
                flickManager!.dispose();
                _controller!.dispose();
              });
            }
          },
          child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15.0, end: 15.0, bottom: 5.0),
              child: _isNetworkAvail
                  ? Container(alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)), child: viewVideo())
                  : const Center(child: CustomTextLabel(text: 'internetmsg'))),
        ));
  }

  viewVideo() {
    return widget.from == 1
        ? widget.model!.contentType == "video_upload"
            ? FlickVideoPlayer(flickManager: flickManager!, flickVideoWithControlsFullscreen: const FlickVideoWithControls(videoFit: BoxFit.fitWidth))
            : widget.model!.contentType == "video_youtube"
                ? YoutubePlayer(controller: _yc!, showVideoProgressIndicator: true, progressIndicatorColor: Theme.of(context).primaryColor)
                : widget.model!.contentType == "video_other"
                    ? Center(child: NewsDetailsVideo(src: widget.model!.contentValue, type: "3"))
                    : const SizedBox.shrink()
        : widget.from == 2
            ? widget.liveModel!.type == "url_youtube"
                ? YoutubePlayer(controller: _yc!, showVideoProgressIndicator: true, progressIndicatorColor: Theme.of(context).primaryColor)
                : Center(child: NewsDetailsVideo(src: widget.liveModel!.url, type: "3"))
            : widget.breakModel!.contentType == "video_upload"
                ? FlickVideoPlayer(flickManager: flickManager!)
                : widget.breakModel!.contentType == "video_youtube"
                    ? YoutubePlayer(controller: _yc!, showVideoProgressIndicator: true, progressIndicatorColor: Theme.of(context).primaryColor)
                    : widget.breakModel!.contentType == "video_other"
                        ? Center(child: NewsDetailsVideo(src: widget.breakModel!.contentValue, type: "3"))
                        : const SizedBox.shrink();
  }
}
