import 'dart:core';
import 'dart:io';

import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Utility/ads_popup.dart';
import 'package:ebook/Utility/share_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_chapter.dart';
class BookDetails extends StatefulWidget {
  final String input;

  BookDetails(this.input);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  String title = '';
  bool isShowing = false;
  bool isBottomSheetOpen = false; // Add this state variable
  bool canShare = false;
  Book? bookDetails;
  BookChapterWithAdsResponse? chaptersResponse;

  final themes = [
    ReadingTheme(Colors.black, Colors.white),
    ReadingTheme(Colors.black, Colors.grey),
    ReadingTheme(Colors.black, Colors.yellowAccent),
    ReadingTheme(Colors.white, Colors.black),
  ];

  int selectedTheme = 0;
  double brightness = 0.0, page_no = 1;
  List<BookWithAdsChapter> chapters = [];
  List<ReadingChapter> reading = [];
  String reviewUrl = "";
  double _counterValue = 17.sp;

  final PageController pageController = PageController(initialPage: 0);
  final List<WebViewController> webViewControllers = [];

  final GlobalKey pageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchData);
  }

  @override
  void dispose() {
    pageController.removeListener(_storedBookListener);
    pageController.removeListener(_basicPageListener);
    pageController.dispose();
    super.dispose();
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (_) {
      return 0.5;
    }
  }

  Color getBackGroundColor() => themes[selectedTheme].color1!;

  Color getTextColor() => themes[selectedTheme].color2!;

  Color getBodyColor() => themes[selectedTheme].color2!;

  String generateHtmlContent(String content, int index) {
    final textColor = getBackGroundColor();
    final bgColor = getTextColor();

    final hexTextColor = '#${textColor.value.toRadixString(16).substring(2)}';
    final hexBgColor = '#${bgColor.value.toRadixString(16).substring(2)}';

    return '''
  <!DOCTYPE html>
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
      * { 
        margin: 0; 
        padding: 0; 
        box-sizing: border-box;
        -webkit-tap-highlight-color: transparent;
      }
      html {
        height: 100%;
        overflow: auto;
        -webkit-overflow-scrolling: touch;
      }
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
        font-size: ${_counterValue}px;
        line-height: 1.6;
        color: $hexTextColor;
        background-color: $hexBgColor;
        padding: 16px;
        min-height: 100%;
        overflow-y: auto;
        overflow-x: hidden;
        -webkit-overflow-scrolling: touch;
        overscroll-behavior-y: contain;
      }
      h1 { font-size: ${_counterValue * 2.2}px; font-weight: bold; margin: 16px 0; text-align: center; color: $hexTextColor; }
      h2 { font-size: ${_counterValue * 1.8}px; font-weight: bold; margin: 12px 0; color: $hexTextColor; }
      h3 { font-size: ${_counterValue * 1.4}px; font-weight: bold; margin: 10px 0; color: $hexTextColor; }
      p { margin: 8px 0; }
      div { margin-bottom: 8px; }
      br { display: block; margin: 8px 0; }
      strong, b { font-weight: bold; }
      ins { text-decoration: underline; }
      hr { margin: 12px 0; border: none; border-bottom: 1px solid ${hexTextColor}4D; }
      img { 
        max-width: 100%; 
        height: auto; 
        display: block; 
        margin: 12px auto; 
        cursor: pointer;
        transition: opacity 0.2s;
      }
      img:hover {
        opacity: 0.8;
      }
      iframe, video { max-width: 100%; height: auto; margin: 12px 0; }
      table { width: 100%; border-collapse: collapse; margin: 12px 0; }
      table, th, td { border: 1px solid ${hexTextColor}4D; padding: 8px; }
      blockquote { border-left: 4px solid ${hexTextColor}4D; padding-left: 16px; margin: 12px 0; font-style: italic; }
      a { color: #2196F3; text-decoration: underline; }
      [style*="text-align:center"], .text-center { text-align: center; }
      [style*="text-align:left"], .text-left { text-align: left; }
      [style*="text-align:right"], .text-right { text-align: right; }
      [style*="text-align:justify"], .text-justify { text-align: justify; text-align-last: left; }
      p[style*="text-align:justify"],
      div[style*="text-align:justify"] { text-align: justify; text-align-last: left; }
    </style>
  </head>
  <body>
    $content
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('img');
        images.forEach(function(img) {
          img.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            window.flutter_inappwebview.callHandler('imageClicked', img.src);
          });
        });
      });
    </script>
  </body>
  </html>
  ''';
  }

  void _initializeAllWebViewControllers() {
    webViewControllers.clear();

    for (int i = 0; i < reading.length; i++) {
      final content = reading[i].desc ?? '';
      webViewControllers.add(createWebViewController(content, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = pageController.hasClients ? (pageController.page?.toInt() ?? 0) : 0;
    final isFirstPage = currentPage == 0;
    final isLastPage = currentPage >= reading.length - 1;

    return Scaffold(
      appBar: isShowing
          ? AppBar(
        iconTheme: IconThemeData(color: getTextColor()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: getTextColor()),
          onPressed: () => Navigation.instance.goBack(),
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: getTextColor(), fontSize: 16.sp),
        ),
        backgroundColor: getBackGroundColor(),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => buildAlertDialog(),
              );
            },
            icon: Icon(Icons.font_download, color: getTextColor()),
          ),
          if (reviewUrl.isNotEmpty)
            IconButton(
              onPressed: () => _launchUrl(reviewUrl),
              icon: Icon(Icons.reviews, color: getTextColor()),
            ),
          if (canShare)
            IconButton(
              onPressed: _shareBook,
              icon: Icon(Icons.share, color: getTextColor()),
            ),
        ],
      )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              key: pageKey,
              height: double.infinity,
              width: double.infinity,
              color: getBodyColor(),
              child: bookDetails == null
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<DataProvider>(
                builder: (context, data, _) {
                  if (chapters.isEmpty) {
                    return Center(
                      child: Text(
                        bookDetails != null ? '' : 'Oops No Data available here',
                        style: TextStyle(color: getBackGroundColor()),
                      ),
                    );
                  }

                  return PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: reading.length,
                    onPageChanged: (val) {
                      final currentReadingPage = reading[val];
                      final actualPageNumber = currentReadingPage.ads_number ?? 0;
                      final isAdPage = chaptersResponse?.isAdPage(actualPageNumber) ?? false;

                      if (isAdPage) {
                        showAds(actualPageNumber);
                      }
                      setState(() {}); // Update FAB visibility
                    },
                    itemBuilder: (context, index) {
                      final content = reading[index].desc ?? '';

                      while (webViewControllers.length <= index) {
                        final idx = webViewControllers.length;
                        final pageContent = reading[idx].desc ?? '';
                        webViewControllers.add(createWebViewController(pageContent, idx));
                      }

                      return Stack(
                        children: [
                          Container(
                            width: 98.w,
                            color: getTextColor(),
                            child: WebViewWidget(
                              controller: webViewControllers[index],
                              gestureRecognizers: {
                                Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer(),
                                ),
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  isShowing = !isShowing;
                                });
                                if (isShowing) {
                                  showBottomSlider(reading.length);
                                }
                              },
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  isShowing = !isShowing;
                                });
                                if (isShowing) {
                                  showBottomSlider(reading.length);
                                }
                              },
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Left Navigation FAB - Only show when bottom sheet is open
            if (!isFirstPage && reading.isNotEmpty && isBottomSheetOpen)
              Positioned(
                left: 3.w,
                top: MediaQuery.of(context).size.height * 0.5 - 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (currentPage > 0) {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Right Navigation FAB - Only show when bottom sheet is open
            if (!isLastPage && reading.isNotEmpty && isBottomSheetOpen)
              Positioned(
                right: 3.w,
                top: MediaQuery.of(context).size.height * 0.5 - 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (currentPage < reading.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void updateWebViewContent() {
    _initializeAllWebViewControllers();
    setState(() {});
  }

  void updateFont(double val) {
    setState(() {
      _counterValue = val;
      updateWebViewContent();
    });
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (context, setInner) {
          return SizedBox(
            width: 50.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: getBackGroundColor(), fontSize: 16.sp),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  height: 4.h,
                  width: 50.w,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      final data = themes[index];
                      return GestureDetector(
                        onTap: () {
                          setInner(() {
                            selectedTheme = index;
                          });
                          setState(updateWebViewContent);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: data.color2,
                            border: Border.all(
                              color: selectedTheme == index ? Colors.blue : data.color2!,
                            ),
                          ),
                          height: 5.h,
                          width: 10.w,
                          child: Center(
                            child: Text(
                              'Aa',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: data.color1, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 3.w),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Font Size",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: getBackGroundColor(), fontSize: 17.sp),
                ),
                SizedBox(height: 0.5.h),
                ToggleSwitch(
                  minWidth: 17.w,
                  minHeight: 4.h,
                  fontSize: 14.sp,
                  initialLabelIndex:
                  _counterValue == 17.sp ? 0 : _counterValue == 20.sp ? 1 : 2,
                  activeBgColor: const [Colors.black87],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 3,
                  labels: const ['17', '20', '22'],
                  onToggle: (index) {
                    if (index == 1) {
                      updateFont(20.sp);
                    } else if (index == 2) {
                      updateFont(22.sp);
                    } else {
                      updateFont(17.sp);
                    }
                  },
                ),
                SizedBox(height: 1.h),
                Text(
                  "Brightness",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: getBackGroundColor(), fontSize: 17.sp),
                ),
                Slider(
                  value: brightness,
                  onChanged: (value) {
                    ScreenBrightness().setScreenBrightness(value);
                    setInner(() {
                      brightness = value;
                    });
                    setState(() {});
                  },
                ),
                SizedBox(height: 1.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareBook() async {
    try {
      const page = "reading";
      final universalLink =
          'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}'
          '&id=${bookDetails?.id}'
          '&details=$page'
          '&page=${pageController.page?.toInt()}'
          '&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}';

      final customSchemeLink =
          'tratri://link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}'
          '&id=${bookDetails?.id}'
          '&details=$page'
          '&page=${pageController.page?.toInt()}'
          '&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}';

      var shareUrl = universalLink;
      if (Platform.isIOS) {
        shareUrl = '$universalLink\n\nAlternative link: $customSchemeLink';
      }

      await ShareHelper.shareFromAppBar(shareUrl, context: context);
    } catch (e) {
      debugPrint('Error sharing: $e');
      try {
        await Share.share(
          'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}'
              '&id=${bookDetails?.id}'
              '&details=reading'
              '&page=${pageController.page?.toInt()}'
              '&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}',
        );
      } catch (fallbackError) {
        debugPrint('Fallback share failed: $fallbackError');
      }
    }
  }

  Future<void> fetchBookDetails() async {
    try {
      final bookId = widget.input.split(',')[0];
      final bookResponse = await ApiProvider.instance.fetchBookDetails(bookId);

      if (!mounted) return;

      if (bookResponse.status ?? false) {
        final details = bookResponse.details;
        final flipBookUrl = details?.flip_book_url;

        if (flipBookUrl?.isNotEmpty ?? false) {
          if (details?.is_bought ?? false) {
            _launchUrl(flipBookUrl!).then((_) => Navigation.instance.goBack());
            Navigation.instance.goBack();
          } else {
            Navigation.instance.goBack();
            Navigation.instance.goBack();
          }
          return;
        }

        if (!(details?.is_bought ?? false)) {
          Navigation.instance.goBack();
          _showPermissionDeniedDialog();
          return;
        }

        setState(() {
          bookDetails = details;
          title = bookDetails?.title ?? "";
          canShare = bookDetails?.status == 2;
        });

        final chaptersResponseLocal =
        await ApiProvider.instance.fetchBookChaptersWithAds(bookId);

        if (!mounted) return;

        if (chaptersResponseLocal.status ?? false) {
          chaptersResponse = chaptersResponseLocal;
          chapters = chaptersResponseLocal.chapters ?? [];
          reading.clear();

          for (final chapter in chapters) {
            if (chapter.pages == null) continue;

            for (final page in chapter.pages!) {
              final content = page.content;
              if (content != null) {
                final currentPageNo = page.current_page_no ?? 0;
                final shouldShowAd = chaptersResponseLocal.isAdPage(currentPageNo);
                reading.add(
                  ReadingChapter(
                    '',
                    content,
                    chapter.review_url,
                    shouldShowAd,
                    currentPageNo,
                  ),
                );
              }
            }
          }

          setState(() {
            reviewUrl = chapters.isNotEmpty ? (chapters[0].review_url ?? "") : "";
          });

          _initializeAllWebViewControllers();
        }

        Navigation.instance.goBack();
      }
    } catch (e) {
      debugPrint('Error fetching book details: $e');
      if (mounted) Navigation.instance.goBack();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('You do not have permission to read this book.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigation.instance.goBack();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showBottomSlider(int total) {
    setState(() {
      isBottomSheetOpen = true; // Set to true when opening
    });

    showCupertinoModalBottomSheet(
      enableDrag: true,
      elevation: 17,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ConstanceData.secondaryColor.withOpacity(0.97),
      topRadius: const Radius.circular(17),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Material(
        child: StatefulBuilder(
          builder: (context, setInner) {
            return Container(
              height: 16.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Page Slider",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  Slider(
                    inactiveColor: Colors.black12,
                    value: pageController.page ?? 1,
                    onChanged: (value) {
                      setInner(() {
                        page_no = value;
                      });
                      pageController.jumpToPage(page_no.toInt());
                      setState(() {});
                    },
                    max: (reading.length - 1).toDouble(),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current: ${pageController.page?.toInt() ?? 0}",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.sp,
                        ),
                      ),
                      Text(
                        "Total: $total",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            );
          },
        ),
      ),
    ).whenComplete(() {
      // Set to false when bottom sheet closes
      setState(() {
        isBottomSheetOpen = false;
      });
    });
  }

  Future<void> _launchUrl(String url) async {
    debugPrint('Launching URL: $url');
  }

  Future<void> fetchData() async {
    try {
      final parts = widget.input.split(',');
      final bookId = parts[0];
      final dialogArg = parts.length > 1 ? parts[1] : '';

      Navigation.instance.navigate('/readingDialog', args: dialogArg);

      await fetchBookDetails();

      brightness = await systemBrightness;

      setState(() {
        Storage.instance.setReadingBook(int.parse(bookId));
      });

      await Future.delayed(const Duration(seconds: 3));

      final storedBookId = Storage.instance.readingBook.toString();
      if (storedBookId == bookId) {
        final storedPage = Storage.instance.readingBookPage;

        if (storedPage > 0 && storedPage < reading.length) {
          _showResumeReadingDialog(storedPage);
        } else {
          pageController.addListener(_basicPageListener);
        }
      } else {
        pageController.addListener(_basicPageListener);
      }
    } catch (e) {
      debugPrint('Error in fetchData: $e');
    }
  }

  void _showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(2.w),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 50.sp,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 2.h,
              right: 2.w,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResumeReadingDialog(int lastReadPage) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Resume Reading',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
            ),
          ),
          content: Text(
            'Would you like to continue from where you left off?\n\nLast read: Page ${lastReadPage +
                1} of ${reading.length}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Start from Beginning'),
              onPressed: () {
                Navigator.of(ctx).pop();
                pageController.addListener(_basicPageListener);
              },
            ),
            TextButton(
              child: const Text('Resume'),
              onPressed: () {
                Navigator.of(ctx).pop();
                try {
                  if (lastReadPage >= 0 && lastReadPage < reading.length) {
                    pageController.jumpToPage(lastReadPage);
                    pageController.addListener(_storedBookListener);
                  } else {
                    pageController.addListener(_basicPageListener);
                  }
                } catch (e) {
                  debugPrint('Error jumping to page: $e');
                  pageController.addListener(_basicPageListener);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _storedBookListener() {
    setState(() {
      page_no = pageController.page ?? 1;
      final idx = pageController.page?.toInt() ?? 0;
      if (idx >= 0 && idx < reading.length) {
        reviewUrl = reading[idx].url ?? "";
      }
    });
    Storage.instance.setReadingBookPage(page_no.toInt());
  }

  void _basicPageListener() {
    setState(() {
      page_no = pageController.page ?? 1;
    });
  }

  void showAds(int adCount) {
    if (adCount <= 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => const AdsPopup(),
    );
  }

  WebViewController createWebViewController(String content, int index) {
    late final WebViewController controller;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(getTextColor())
      ..addJavaScriptChannel(
        'imageClicked',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle image click
          _showImagePopup(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint('WebView start: $url'),
          onPageFinished: (url) {
            // Inject JavaScript to handle image clicks
            controller.runJavaScript('''
            document.addEventListener('click', function(e) {
              if (e.target.tagName === 'IMG') {
                e.preventDefault();
                e.stopPropagation();
                imageClicked.postMessage(e.target.src);
              }
            }, true);
          ''');
            debugPrint('WebView finished: $url');
          },
          onWebResourceError: (error) =>
              debugPrint('WebView error: ${error.description}'),
          onNavigationRequest: (request) {
            if (request.url.startsWith('http://') ||
                request.url.startsWith('https://')) {
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(generateHtmlContent(content, index));

    return controller;
  }
}