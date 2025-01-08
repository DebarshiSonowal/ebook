class EnotesChapterListResponse {
  final bool success;
  final EnotesChapterResults result;
  final String message;
  final int code;

  EnotesChapterListResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnotesChapterListResponse.fromJson(Map<String, dynamic> json) {
    return EnotesChapterListResponse(
      success: json['success'],
      result: EnotesChapterResults.fromJson(json['result']),
      message: json['message'],
      code: json['code'],
    );
  }
  factory EnotesChapterListResponse.withError(String message) {
    return EnotesChapterListResponse(
      success: false,
      result: EnotesChapterResults(
        chapterList: [],
        totalPages: 0,
        totalChapters: 0,
      ),
      message: message,
      code: 400,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.toJson(),
      'message': message,
      'code': code,
    };
  }
}

class EnotesChapterResults {
  final List<Chapter> chapterList;
  final int totalPages;
  final int totalChapters;

  EnotesChapterResults({
    required this.chapterList,
    required this.totalPages,
    required this.totalChapters,
  });

  factory EnotesChapterResults.fromJson(Map<String, dynamic> json) {
    return EnotesChapterResults(
      chapterList: (json['chapter_list'] as List)
          .map((e) => Chapter.fromJson(e))
          .toList(),
      totalPages: json['total_pages'],
      totalChapters: json['total_chapters'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_list': chapterList.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_chapters': totalChapters,
    };
  }
}

class Chapter {
  final int aD;
  final String title;
  final String subTitle;
  final bool showTitle;
  final String slug;
  final int sequence;
  final String reviewUrl;
  final int firstPageNo;
  final int lastPageNo;
  final List<String> pages;

  Chapter({
    required this.aD,
    required this.title,
    required this.subTitle,
    required this.showTitle,
    required this.slug,
    required this.sequence,
    required this.reviewUrl,
    required this.firstPageNo,
    required this.lastPageNo,
    required this.pages,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      aD: json['a_d'],
      title: json['title'],
      subTitle: json['sub_title'],
      showTitle: json['show_title'],
      slug: json['slug'],
      sequence: json['sequence'],
      reviewUrl: json['review_url'],
      firstPageNo: json['first_page_no'],
      lastPageNo: json['last_page_no'],
      pages: List<String>.from(json['pages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'a_d': aD,
      'title': title,
      'sub_title': subTitle,
      'show_title': showTitle,
      'slug': slug,
      'sequence': sequence,
      'review_url': reviewUrl,
      'first_page_no': firstPageNo,
      'last_page_no': lastPageNo,
      'pages': pages,
    };
  }
}
