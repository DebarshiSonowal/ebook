class HomeBannerResponse {
  bool? status;
  String? message;
  List<HomeBanner>? banners;

  HomeBannerResponse.fromJson(json){
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    banners = json['result'] == null ? [] : (json['result'] as List).map((e) =>
        HomeBanner.fromJson(e)).toList();
  }
  HomeBannerResponse.withError(msg){
    status = false;
    message = msg??"Something went wrong";
  }

}


class HomeBanner {
  int? id, book_category_id;
  String? title, writer, book_format, category, profile_pic;

  HomeBanner.fromJson(json) {
    id = json['id'] ?? 0;
    book_category_id = json['book_category_id'] ?? 0;
    title = json['title'] ?? "";
    writer = json['writer'] ?? "";
    book_format = json['book_format'] ?? "";
    category = json['category'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
  }
}
