// Updated model classes to handle the new chapters API response structure
//
// IMPORTANT: Ad Display Logic
// - Use `ad_pages` field to determine which pages should show ads
// - `view_ad_count` is NOT related to ad display - it's for analytics/tracking only
//
// Example usage:
// final response = await ApiProvider.instance.fetchBookChaptersWithAds(bookId);
// if (response.status ?? false) {
//   final chapters = response.chapters ?? [];
//   final adPages = response.getAdPageNumbers(); // Gets [5, 11, 18, 24, ...]
//
//   for (final chapter in chapters) {
//     for (final page in chapter.pages ?? []) {
//       final content = page.content;
//       final currentPage = page.current_page_no ?? 0;
//       final shouldShowAd = response.isAdPage(currentPage); // ✅ Correct way to check for ads
//       // ❌ DON'T use view_ad_count for ad display logic
//
//       if (shouldShowAd) {
//         // Show advertisement
//       }
//     }
//   }
// }

class BookChapterWithAdsResponse {
  bool? status;
  String? message;
  List<BookWithAdsChapter>? chapters;
  int? total_pages, total_chapters;
  String? ad_pages;

  BookChapterWithAdsResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    total_pages = json['result']['total_pages'] ?? 0;
    total_chapters = json['result']['total_chapters'] ?? 0;
    ad_pages = json['result']['ad_pages'] ?? "";
    chapters = json['result']['chapter_list'] == null
        ? []
        : (json['result']['chapter_list'] as List)
            .map((e) => BookWithAdsChapter.fromJson(e))
            .toList();
  }

  BookChapterWithAdsResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }

  // Helper method to get ad page numbers as a list
  List<int> getAdPageNumbers() {
    if (ad_pages == null || ad_pages!.isEmpty) return [];
    var value = ad_pages!
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .where((n) => n > 0)
        .toList();
    print("Ads pages: ${value}");
    return value;
  }

  // Helper method to check if a specific page number is an ad page
  bool isAdPage(int pageNumber) {
    return getAdPageNumbers().contains(pageNumber);
  }
}

class BookWithAdsChapter {
  String? title, sub_title, slug, review_url;
  List<PageModel>? pages;
  int? sequence, first_page_no, last_page_no, a_d;
  bool? show_title;

  BookWithAdsChapter.fromJson(json) {
    title = json['title'] ?? "";
    sub_title = json['sub_title'] ?? "";
    slug = json['slug'] ?? "";

    sequence = json['sequence'] ?? 0;
    first_page_no = json['first_page_no'] ?? 0;
    last_page_no = json['last_page_no'] ?? 0;
    a_d = json['a_d'] ?? 0;

    show_title = json['show_title'] ?? false;
    review_url = json['review_url'] ?? "";
    pages = json['pages'] == null
        ? []
        : (json['pages'] as List).map((e) => PageModel.fromJson(e)).toList();
  }
}

class PageModel {
  String? content;
  int? view_ad_count, current_page_no;

  PageModel.fromJson(json) {
    content = json['content'] ?? "";
    view_ad_count = json['view_ad_count'] ?? 0;
    current_page_no = json['current_page_no'] ?? 0;
  }
}
