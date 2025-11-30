import 'dart:io';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_chapter.dart';
import '../../../Model/reading_theme.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/app_storage.dart';
import '../../../Storage/data_provider.dart';
import '../../../Utility/ads_popup.dart';
import '../../../Utility/share_helper.dart';
import '../../Components/dynamicSize.dart';
import '../../Components/splittedText.dart';

class MagazineDetailsPage extends StatefulWidget {
  final String id;

  MagazineDetailsPage(this.id);

  @override
  State<MagazineDetailsPage> createState() => _MagazineDetailsPageState();
}

class _MagazineDetailsPageState extends State<MagazineDetailsPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  List<ReadingChapter> reading = [];
  Book? bookDetails;
  bool canShare = false;

  var themes = [
    ReadingTheme(Colors.black, Colors.white),
    ReadingTheme(Colors.white, Colors.black),
    ReadingTheme(Colors.black, Colors.grey.shade300),
    ReadingTheme(Colors.black, Colors.yellow.shade100),
  ];

  int selectedTheme = 0;
  double brightness = 0.0, page_no = 1;
  bool toggle = false;
  double sliderVal = 0;

  PageController pageController = PageController(initialPage: 0);
  List<WebViewController> webViewControllers = [];
  List<BookWithAdsChapter> chapters = [];

  var _counterValue = 17.sp;
  var text = "";
  String reviewUrl = "";

  DynamicSize _dynamicSize = DynamicSizeImpl();
  SplittedText _splittedText = SplittedTextImpl();
  Size? _size;
  List<String> _splittedTextList = [];

  final GlobalKey pageKey = GlobalKey();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchBookDetails();

    Future.delayed(Duration.zero, () async {
      getSizeFromBloc(pageKey);
      brightness = await systemBrightness;
      try {
        Navigation.instance.navigate('/readingDialog',
            args: widget.id.toString().split(',')[2]);
      } catch (e) {
        print(e);
      }
      setState(() {
        Storage.instance
            .setReadingBook(int.parse(widget.id.toString().split(',')[0]));
      });
    });

    pageController.addListener(() {
      setState(() {
        reviewUrl = reading[pageController.page!.toInt()].url ?? "";
      });
      page_no = pageController.page ?? 1;
    });
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (e) {
      print(e);
      return 0.5;
    }
  }

  // Generate HTML wrapper for WebView
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
            }
            
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
                font-size: ${_counterValue}px;
                line-height: 1.6;
                color: $hexTextColor;
                background-color: $hexBgColor;
                padding: 16px;
                overflow-x: hidden;
            }
            
            h1 {
                font-size: ${_counterValue * 1.8}px;
                font-weight: bold;
                margin: 16px 0;
                text-align: center;
                color: $hexTextColor;
            }
            
            h2 {
                font-size: ${_counterValue * 1.5}px;
                font-weight: bold;
                margin: 12px 0;
                color: $hexTextColor;
            }
            
            h3 {
                font-size: ${_counterValue * 1.3}px;
                font-weight: bold;
                margin: 10px 0;
                color: $hexTextColor;
            }
            
            p {
                margin: 8px 0;
            }
            
            div {
                margin-bottom: 8px;
            }
            
            br {
                display: block;
                margin: 8px 0;
            }
            
            strong, b {
                font-weight: bold;
            }
            
            ins {
                text-decoration: underline;
            }
            
            hr {
                margin: 12px 0;
                border: none;
                border-bottom: 1px solid ${hexTextColor}4D;
            }
            
            img {
                max-width: 100%;
                height: auto;
                display: block;
                margin: 12px auto;
            }
            
            iframe, video {
                max-width: 100%;
                height: auto;
                margin: 12px 0;
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 12px 0;
            }
            
            table, th, td {
                border: 1px solid ${hexTextColor}4D;
                padding: 8px;
            }
            
            blockquote {
                border-left: 4px solid ${hexTextColor}4D;
                padding-left: 16px;
                margin: 12px 0;
                font-style: italic;
            }
            
            a {
                color: #2196F3;
                text-decoration: underline;
            }
            
            /* Text alignment classes */
            [style*="text-align:center"], .text-center {
                text-align: center;
            }
            
            [style*="text-align:left"], .text-left {
                text-align: left;
            }
            
            [style*="text-align:right"], .text-right {
                text-align: right;
            }
            
            [style*="text-align:justify"], .text-justify {
                text-align: justify;
                text-align-last: left;
            }
            
            /* Apply text-align-last to justified paragraphs and divs */
            p[style*="text-align:justify"], 
            div[style*="text-align:justify"] {
                text-align: justify;
                text-align-last: left;
            }
        </style>
    </head>
    <body>
        $content
    </body>
    </html>
    ''';
  }

  // Create WebViewController for a page
  WebViewController createWebViewController(String content, int index) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(getTextColor())
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle external links
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

  // Update WebView content when theme/font changes
  void updateWebViewContent() {
    for (int i = 0; i < reading.length && i < webViewControllers.length; i++) {
      String content = reading[i].desc ?? '';
      webViewControllers[i].loadHtmlString(generateHtmlContent(content, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: getBodyColor(),
        key: pageKey,
        child: bookDetails == null
            ? const Center(child: CircularProgressIndicator())
            : Consumer<DataProvider>(
          builder: (context, data, _) {
            return chapters.isEmpty
                ? Center(
              child: Text(
                bookDetails != null ? '' : 'Oops No Data available here',
                style: TextStyle(
                    color: getBackGroundColor(), fontSize: 14.sp),
              ),
            )
                : PageView.builder(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: reading.length,
              onPageChanged: (val) {
                if (reading[val].viewAds ?? false) {
                  showAds(reading[val].ads_number);
                }
              },
              itemBuilder: (context, index) {
                String content = reading[index].desc ?? '';

                // Create or reuse WebViewController
                if (index >= webViewControllers.length) {
                  webViewControllers.add(createWebViewController(content, index));
                }

                return GestureDetector(
                  onTap: () {
                    showBottomSlider(reading.length);
                  },
                  child: Container(
                    width: 98.w,
                    color: getTextColor(),
                    child: WebViewWidget(
                      controller: webViewControllers[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: getTextColor()),
      title: Text(
        bookDetails?.title ?? "",
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(color: getTextColor(), fontSize: 16.sp),
      ),
      backgroundColor: getBackGroundColor(),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => buildAlertDialog(),
            );
          },
          icon: Icon(Icons.font_download, color: getTextColor()),
        ),
        if (reviewUrl != "")
          IconButton(
            onPressed: () {
              debugPrint(reviewUrl);
              _launchUrl(reviewUrl);
            },
            icon: Icon(Icons.reviews, color: getTextColor()),
          ),
        if (canShare)
          IconButton(
            onPressed: () async {
              String page = "reading";
              final shareUrl =
                  'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}&id=${bookDetails?.id}&details=$page&count=${widget.id.toString().split(",")[1]}&page=${pageController.page?.toInt()}';
              await ShareHelper.shareText(shareUrl, context: context);
            },
            icon: Icon(Icons.share, color: getTextColor()),
          ),
      ],
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (context, _) {
          return SizedBox(
            width: 50.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: getBackGroundColor(), fontSize: 15.sp),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  height: 4.h,
                  width: 50.w,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: themes.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = themes[index];
                      return GestureDetector(
                        onTap: () {
                          _(() {
                            setState(() {
                              selectedTheme = index;
                              updateWebViewContent();
                            });
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: data.color2,
                            border: Border.all(
                              color: selectedTheme == index
                                  ? Colors.blue
                                  : data.color2!,
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
                                  ?.copyWith(color: data.color1, fontSize: 17.sp),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 3.w);
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Font Size",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: getBackGroundColor(), fontSize: 15.sp),
                ),
                SizedBox(height: 0.5.h),
                ToggleSwitch(
                  minWidth: 15.w,
                  minHeight: 4.h,
                  fontSize: 14.sp,
                  initialLabelIndex: (_counterValue == 17.sp
                      ? 0
                      : _counterValue == 19.sp
                      ? 1
                      : 2) ??
                      0,
                  activeBgColor: [Colors.black87],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 3,
                  labels: ['17', '19', '22'],
                  onToggle: (index) {
                    switch (index) {
                      case 1:
                        updateFont(19.sp);
                        break;
                      case 2:
                        updateFont(22.sp);
                        break;
                      default:
                        updateFont(17.sp);
                    }
                  },
                ),
                SizedBox(height: 1.h),
                Text(
                  "Brightness",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: getBackGroundColor(), fontSize: 15.sp),
                ),
                Slider(
                  inactiveColor: Colors.grey.shade800,
                  value: brightness,
                  onChanged: (value) {
                    _(() {
                      ScreenBrightness().setScreenBrightness(value);
                      setState(() {
                        brightness = value;
                      });
                    });
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

  void showBottomSlider(total) {
    showCupertinoModalBottomSheet(
      enableDrag: true,
      elevation: 15,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ConstanceData.secondaryColor.withOpacity(0.97),
      topRadius: const Radius.circular(15),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Material(
        child: StatefulBuilder(
          builder: (context, _) {
            return Container(
              height: 14.h,
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
                      fontSize: 14.sp,
                    ),
                  ),
                  Slider(
                    value: pageController.page ?? 1,
                    onChanged: (value) {
                      _(() {
                        page_no = value;
                        pageController.jumpToPage(page_no.toInt());
                      });
                      setState(() {});
                    },
                    max: reading.length.toDouble(),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current: ${pageController.page}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "Total: $total",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
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
    );
  }

  getBackGroundColor() => themes[selectedTheme].color1;
  getTextColor() => themes[selectedTheme].color2;
  getBodyColor() => themes[selectedTheme].color2;

  getSizeFromBloc(GlobalKey pagekey) {
    _size = _dynamicSize.getSize(pagekey);
    print(_size);
  }

  getSplittedText(TextStyle textStyle, txt) {
    _splittedTextList = _splittedText.getSplittedText(_size!, textStyle, txt);
  }

  void fetchBookDetails() async {
    final bookId = widget.id.toString().split(',')[0];

    // Make parallel API calls
    final futures = await Future.wait([
      ApiProvider.instance.fetchBookDetails(bookId),
      ApiProvider.instance.fetchBookChaptersWithAds(bookId),
    ]);

    // Handle book details response
    final bookResponse = futures[0] as BookDetailsResponse;
    if (bookResponse.status ?? false) {
      bookDetails = bookResponse.details;
      if (mounted) {
        setState(() {});
      }
    }

    // Handle chapters response
    final chaptersResponse = futures[1] as BookChapterWithAdsResponse;
    if (chaptersResponse.status ?? false) {
      chapters = chaptersResponse.chapters ?? [];
      setState(() {
        reviewUrl = chaptersResponse.chapters?[0].review_url ?? "";
        debugPrint("ReviewUrl: $reviewUrl");
      });

      for (int i = 0; i < chapters.length; i++) {
        for (var j in chapters[i].pages!) {
          if (i >= int.parse(widget.id.toString().split(',')[1])) {
            final currentPageNo = j.current_page_no ?? 0;
            final shouldShowAd = chaptersResponse.isAdPage(currentPageNo);
            reading.add(ReadingChapter(
              chapters[i].title,
              j.content,
              chapters[i].review_url,
              shouldShowAd,
              j.view_ad_count,
            ));
            text = text + j.content!;
          }
        }
      }

      if (mounted) {
        setState(() {
          getSplittedText(
            TextStyle(
              color: getBackGroundColor(),
              fontSize: _counterValue,
            ),
            text,
          );
        });
      }
    }

    Navigation.instance.goBack();
    setState(() {
      canShare = bookDetails?.status == 2;
    });
  }

  void updateFont(val) {
    setState(() {
      _counterValue = val.toDouble();
      updateWebViewContent();
      getSplittedText(
        TextStyle(
          color: getBackGroundColor(),
          fontSize: _counterValue,
        ),
        text,
      );
    });
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.startsWith('file://')) {
        url = 'https://$url';
      }

      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  void showAds(int? adCount) {
    if (adCount == null || adCount <= 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return const AdsPopup();
      },
    );
  }
}