import 'home_banner.dart';

class HomeSectionResponse {
  bool? status;
  String? message;
  List<HomeSection>? sections;

  HomeSectionResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    sections = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => HomeSection.fromJson(e)).toList();
  }

  HomeSectionResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class HomeSection {
  String? title;
  List<HomeBanner>? book;

  HomeSection.fromJson(json) {
    title = json['title'] ?? "";
    book = json['books'] == null
        ? []
        : (json['books'] as List).map((e) => HomeBanner.fromJson(e)).toList();
  }
}
