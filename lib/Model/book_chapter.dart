class BookChapterResponse {
  bool? status;
  String? message;
  List<BookChapter>? chapters;
  int? total_pages, total_chapters;

  BookChapterResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    total_pages = json['result']['total_pages'] ?? 0;
    total_chapters = json['result']['total_chapters'] ?? 0;
    chapters = json['result']['chapter_list'] == null
        ? []
        : (json['result']['chapter_list'] as List)
            .map((e) => BookChapter.fromJson(e))
            .toList();
  }

  BookChapterResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class BookChapter {
  String? title, sub_title, slug, review_url;
  List<String>? pages;
  int? sequence, first_page_no, last_page_no;
  bool? show_title;

  BookChapter.fromJson(json) {
    title = json['title'] ?? "";
    sub_title = json['sub_title'] ?? "";
    slug = json['slug'] ?? "";

    sequence = json['sequence'] ?? 0;
    first_page_no = json['first_page_no'] ?? 0;
    last_page_no = json['last_page_no'] ?? 0;

    show_title = json['show_title'] ?? false;
    review_url = json['review_url'] ?? "";
    pages = json['pages'] == null
        ? []
        : (json['pages'] as List).map((e) => e.toString()).toList();
  }
}

class BookChapterWithAdsResponse {
  bool? status;
  String? message;
  List<BookChapter>? chapters;
  int? total_pages, total_chapters;

  BookChapterWithAdsResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    total_pages = json['result']['total_pages'] ?? 0;
    total_chapters = json['result']['total_chapters'] ?? 0;
    chapters = json['result']['chapter_list'] == null
        ? []
        : (json['result']['chapter_list'] as List)
            .map((e) => BookChapter.fromJson(e))
            .toList();
  }

  BookChapterWithAdsResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class BookWithAdsChapter {
  String? title, sub_title, slug, review_url;
  List<PageModel>? pages;
  int? sequence, first_page_no, last_page_no;
  bool? show_title;

  BookWithAdsChapter.fromJson(json) {
    title = json['title'] ?? "";
    sub_title = json['sub_title'] ?? "";
    slug = json['slug'] ?? "";

    sequence = json['sequence'] ?? 0;
    first_page_no = json['first_page_no'] ?? 0;
    last_page_no = json['last_page_no'] ?? 0;

    show_title = json['show_title'] ?? false;
    review_url = json['review_url'] ?? "";
    pages = json['pages'] == null
        ? []
        : (json['pages'] as List).map((e) => PageModel.fromJson(e)).toList();
  }
}

class PageModel {
  String? content;
  bool? view_ad;
  int? view_ad_count;

  PageModel.fromJson(json) {
    content = json['content'] ?? "";
    view_ad = json['view_ad'] ?? false;
    view_ad_count = json['view_ad_count'] ?? 0;
  }
}
