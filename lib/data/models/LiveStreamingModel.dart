import 'package:news/utils/strings.dart';

class LiveStreamingModel {
  String? id, image, title, type, url;

  LiveStreamingModel({this.id, this.image, this.title, this.type, this.url});

  factory LiveStreamingModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamingModel(id: json[ID].toString(), image: json[IMAGE], title: json[TITLE], type: json[TYPE], url: json[URL]);
  }
}
