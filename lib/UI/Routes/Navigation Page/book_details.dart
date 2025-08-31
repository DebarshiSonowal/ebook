import 'dart:core';
import 'dart:io';

import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Utility/ads_popup.dart';
import 'package:ebook/Utility/blockquote_extention.dart';
import 'package:ebook/Utility/share_helper.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_chapter.dart';
import '../../../Utility/embeded_link_extenion.dart';
import '../../../Utility/image_extension.dart';
import '../../../Utility/spaceExtension.dart';
import '../../Components/dynamicSize.dart';
import '../../Components/splittedText.dart';

class BookDetails extends StatefulWidget {
  final String input;

  // final String coverImage;

  BookDetails(this.input);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  String title = '';

  // WebViewController? _controller;

  String background = "https://picsum.photos/id/237/200/300";
  bool isShowing = false;
  bool canShare = false;
  Book? bookDetails;
  BookChapterWithAdsResponse? chaptersResponse;
  var themes = [
    ReadingTheme(
      Colors.black,
      Colors.white,
    ),
    ReadingTheme(
      Colors.black,
      Colors.grey.shade300,
    ),
    ReadingTheme(
      Colors.black,
      Colors.yellow.shade100,
    ),
    ReadingTheme(
      Colors.white,
      Colors.black,
    ),
  ];

  List<String> pageText = [];
  int selectedTheme = 0;
  double brightness = 0.0, page_no = 1;
  bool toggle = false;
  double sliderVal = 0;
  List<BookWithAdsChapter> chapters = [];
  List<ReadingChapter> reading = [];
  String read = '', reviewUrl = "";
  var _counterValue = 17.sp;
  PageController pageController = PageController(
    initialPage: 0,
  );
  var test = '''''';
  final DynamicSize _dynamicSize = DynamicSizeImpl();
  final SplittedText _splittedText = SplittedTextImpl();
  Size? _size;
  List<String> _splittedTextList = [];

  final GlobalKey pageKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();

    // removeScreenshotDisable();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => fetchData());
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (e) {
      print(e);
      throw 'Failed to get system brightness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isShowing
          ? AppBar(
              iconTheme: IconThemeData(color: getTextColor()),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: getTextColor(),
                ),
                onPressed: () {
                  Navigation.instance.goBack();
                },
              ),
              title: Text(
                title ?? "",
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
                      builder: (BuildContext context) {
                        // initPlatformBrightness();
                        return buildAlertDialog();
                      },
                    );
                  },
                  icon: Icon(
                    Icons.font_download,
                    color: getTextColor(),
                  ),
                ),
                (reviewUrl != "")
                    ? IconButton(
                        onPressed: () {
                          debugPrint(reviewUrl);
                          _launchUrl(reviewUrl);
                        },
                        icon: Icon(
                          Icons.reviews,
                          color: getTextColor(),
                        ),
                      )
                    : Container(),
                canShare
                    ? IconButton(
                        onPressed: () async {
                          try {
                            String page = "reading";
                            final universalLink =
                                'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}&id=${bookDetails?.id}&details=$page&page=${pageController.page?.toInt()}&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}';

                            final customSchemeLink =
                                'tratri://link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}&id=${bookDetails?.id}&details=$page&page=${pageController.page?.toInt()}&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}';

                            // Try universal link first, fallback to custom scheme
                            String shareUrl = universalLink;

                            // For iOS, also include custom scheme as fallback
                            if (Platform.isIOS) {
                              shareUrl =
                                  '$universalLink\n\nAlternative link: $customSchemeLink';
                            }

                            // Use the specialized app bar share method
                            await ShareHelper.shareFromAppBar(
                              shareUrl,
                              context: context,
                            );
                          } catch (e) {
                            debugPrint('Error sharing: $e');
                            // Fallback to simple share without position on any platform
                            try {
                              await Share.share(
                                'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}&id=${bookDetails?.id}&details=reading&page=${pageController.page?.toInt()}&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}',
                              );
                            } catch (fallbackError) {
                              debugPrint(
                                  'Fallback share also failed: $fallbackError');
                            }
                          }
                        },
                        icon: Icon(
                          Icons.share,
                          color: getTextColor(),
                        ),
                      )
                    : Container(),
              ],
            )
          : null,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: getBodyColor(),
          key: pageKey,
          child: bookDetails == null
              ? const Center(child: CircularProgressIndicator())
              : Consumer<DataProvider>(builder: (context, data, _) {
                  return chapters.isEmpty
                      ? Center(
                          child: Text(
                            bookDetails != null
                                ? ''
                                : 'Oops No Data available here',
                            style: TextStyle(
                              color: getBackGroundColor(),
                            ),
                          ),
                        )
                      : PageView.builder(
                          // shrinkWrap: true,
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: reading.length,
                          onPageChanged: (val) {
                            // Get the actual page number from the reading chapter
                            final currentReadingPage = reading[val];
                            final actualPageNumber =
                                currentReadingPage.ads_number ??
                                    0; // This stores current_page_no
                            final isAdPage =
                                chaptersResponse?.isAdPage(actualPageNumber) ??
                                    false;

                            debugPrint(
                                'Reading Page Index: $val, Actual Page Number: $actualPageNumber, Is Ad Page: $isAdPage');

                            if (isAdPage) {
                              debugPrint(
                                  'Showing ad for page: $actualPageNumber');
                              showAds(actualPageNumber);
                            }
                          },
                          itemBuilder: (context, index) {
                            test = reading[index].desc!;
                            debugPrint(test);
                            return GestureDetector(
                              onTap: () {
                                // Navigation.instance.goBack();
                                setState(() {
                                  isShowing = !isShowing;
                                });
                                showBottomSlider(reading.length);
                              },
                              child: Container(
                                width: 98.w,
                                // height: 90.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                color: getTextColor(),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Html(
                                        data: test,
                                        // onLinkTap: (str, contxt, map, elment) {
                                        //   debugPrint(str);
                                        //   _launchUrl(Uri.parse(
                                        //       str ?? "https://tratri.in/"));
                                        // },
                                        style: {
                                          '#': Style(
                                            fontSize: FontSize(_counterValue),
                                            // maxLines: 22,
                                            color: getBackGroundColor(),
                                            // textOverflow: TextOverflow.ellipsis,
                                          ),
                                        },
                                        extensions: const [
                                          IframeHtmlExtension(),
                                          TableHtmlExtension(),
                                          VideoHtmlExtension(),
                                          EmbeddedLinkExtension(2),
                                          BlockquoteExtension(),
                                          CustomImageExtension(),
                                          CustomSpaceExtension(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      // title: Text('Welcome'),
      content: StatefulBuilder(builder: (context, _) {
        return SizedBox(
          // height: 22.h,
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
                    ?.copyWith(color: getBackGroundColor(), fontSize: 16.sp),
              ),
              SizedBox(
                height: 1.h,
              ),
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
                            // _loadHtmlFromAssets(test, list_bg_color[index],
                            //     list_txt_color[index], _counterValue);
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.color2,
                            border: Border.all(
                                color: selectedTheme == index
                                    ? Colors.blue
                                    : data.color2!)),
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
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 3.w,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Font Size",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: getBackGroundColor(), fontSize: 17.sp),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              ToggleSwitch(
                minWidth: 17.w,
                minHeight: 4.h,
                fontSize: 14.sp,
                initialLabelIndex: (_counterValue == 17.sp
                        ? 0
                        : _counterValue == 20.sp
                            ? 1
                            : 2) ??
                    0,
                activeBgColor: const [Colors.black87],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.grey[900],
                totalSwitches: 3,
                labels: const ['17', '20', '22'],
                onToggle: (index) {
                  switch (index) {
                    case 1:
                      updateFont(20.sp);
                      break;
                    case 2:
                      updateFont(22.sp);
                      break;
                    default:
                      updateFont(17.sp);
                  }
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Brightness",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: getBackGroundColor(), fontSize: 17.sp),
              ),
              Slider(
                  value: brightness,
                  onChanged: (value) {
                    ScreenBrightness().setScreenBrightness(value);
                    _(() {
                      setState(() {
                        brightness = value;
                      });
                    });
                  }),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        );
      }),
    );
  }

  getBackGroundColor() {
    switch (selectedTheme) {
      // case 0:
      //   return themes[selectedTheme].color1;
      // case 1:
      //   return themes[selectedTheme].color1;
      default:
        return themes[selectedTheme].color1;
    }
  }

  getTextColor() {
    switch (selectedTheme) {
      // case 0:
      //   return themes[selectedTheme].color2;
      // case 1:
      //   return themes[selectedTheme].color2;
      default:
        return themes[selectedTheme].color2;
    }
  }

  getBodyColor() {
    switch (selectedTheme) {
      // case 0:
      //   return themes[selectedTheme].color2;
      // case 1:
      //   return themes[selectedTheme].color2;
      default:
        return themes[selectedTheme].color2;
    }
  }

  void setScreenshotDisable() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void removeScreenshotDisable() async {
    // await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> fetchBookDetails() async {
    try {
      final bookId = widget.input.toString().split(',')[0];

      // First, fetch only book details to check permissions
      final bookResponse = await ApiProvider.instance.fetchBookDetails(bookId);

      if (!mounted) return;

      // Handle book details response
      if (bookResponse.status ?? false) {
        // Handle flip book URL if present
        final flipBookUrl = bookResponse.details?.flip_book_url;
        if (flipBookUrl?.isNotEmpty ?? false) {
          if ((bookResponse.details?.is_bought ?? false)) {
            _launchUrl(flipBookUrl).then((e) => {
                  Navigation.instance.goBack(),
                  Navigation.instance.goBack(),
                });
          } else {
            Navigation.instance.goBack();
            Navigation.instance.goBack();
          }
          return;
        }

        // Check if user has permission to read the book
        debugPrint("User has permission to read the book ${bookResponse.details?.is_bought}");
        if (!(bookResponse.details?.is_bought ?? false)) {
          Navigation.instance.goBack(); // Close loading dialog first
          _showPermissionDeniedDialog();
          return; // Don't proceed with chapters API
        }

        setState(() {
          bookDetails = bookResponse.details;
          title = bookDetails?.title ?? "";
          canShare = bookDetails?.status == 2; // Check book details status
        });

        // Only fetch chapters if user has permission
        final chaptersResponse =
            await ApiProvider.instance.fetchBookChaptersWithAds(bookId);

        if (!mounted) return;

        if (chaptersResponse.status ?? false) {
          // Store the chapters response for ad checking
          this.chaptersResponse = chaptersResponse;
          chapters = chaptersResponse.chapters ?? [];

          // Debug: Print ad pages
          final adPages = chaptersResponse.getAdPageNumbers();
          debugPrint("Ad Pages configured: $adPages");

          reading.clear();
          read = "";

          // Process each chapter and page
          for (final chapter in chapters) {
            if (chapter.pages == null) continue;

            for (final page in chapter.pages!) {
              final content = page.content;
              if (content != null) {
                final currentPageNo = page.current_page_no ?? 0;
                final shouldShowAd = chaptersResponse.isAdPage(currentPageNo);
                debugPrint(
                    "Page: $currentPageNo, Should Show Ad: $shouldShowAd");
                reading.add(ReadingChapter('', content, chapter.review_url,
                    shouldShowAd, currentPageNo));
                read += content;
              }
            }
          }

          setState(() {
            reviewUrl = chapters.isNotEmpty ? chapters[0].review_url ?? "" : "";
            getSplitedText(
                TextStyle(
                    color: getBackGroundColor(),
                    fontSize: FontSize(_counterValue).value),
                read);
          });
        }

        Navigation.instance.goBack();
      }
    } catch (e) {
      debugPrint('Error fetching book details: $e');
      Navigation.instance.goBack();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button dismissal
          child: AlertDialog(
            title: Text('Permission Denied'),
            content: Text('You do not have permission to read this book.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigation.instance.goBack(); // Go back to previous screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  getSizeFromBloc(GlobalKey pagekey) {
    _size = _dynamicSize.getSize(pagekey);
  }

  void updateFont(val) {
    setState(() {
      _counterValue = val.toDouble();
      getSplitedText(
          TextStyle(
              color: getBackGroundColor(),
              fontSize: FontSize(_counterValue).value),
          read);
    });
  }

  getSplitedText(TextStyle textStyle, txt) {
    try {
      _splittedTextList = _splittedText.getSplittedText(_size!, textStyle, txt);
    } catch (e) {
      print(e);
    }
  }

  void showBottomSlider(total) {
    showCupertinoModalBottomSheet(
      enableDrag: true,
      // expand: true,
      elevation: 17,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ConstanceData.secondaryColor.withOpacity(0.97),
      topRadius: const Radius.circular(17),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Material(
        child: StatefulBuilder(builder: (context, _) {
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
                    _(() {
                      page_no = value;
                      pageController.jumpToPage(
                        page_no.toInt(),
                      );
                    });
                    setState(() {});

                    if (page_no == 0) {
                      toggle = true;
                    } else {
                      toggle = false;
                    }
                  },
                  max: reading.length.toDouble(),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current: ${pageController.page?.toInt()}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                    ),
                    Text(
                      "Total: ${total}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    try {
      String url = _url.toString();
      // Handle URLs that don't have a protocol
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.startsWith('file://')) {
        url = 'https://$url';
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          );
        },
      );

      // Launch with in-app web view with loading indicator
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          },
        ),
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Close loading dialog on error
      if (mounted) {
        Navigator.of(context).pop();
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load content'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchData() async {
    try {
      final bookId = widget.input.toString().split(',')[0];
      final dialogArg = widget.input.toString().split(',')[1];

      Navigation.instance.navigate('/readingDialog', args: dialogArg);

      await fetchBookDetails();

      // Initialize brightness and size
      brightness = await systemBrightness;
      getSizeFromBloc(pageKey);

      // Set reading book in storage
      setState(() {
        Storage.instance.setReadingBook(int.parse(bookId));
      });

      // Setup page controller after brief delay
      await Future.delayed(const Duration(seconds: 3));

      final storedBookId = Storage.instance.readingBook.toString();
      if (storedBookId == bookId) {
        final storedPage = Storage.instance.readingBookPage;
        pageController.jumpToPage(storedPage); 

        // Add listener for stored book
        pageController.addListener(_storedBookListener);
      } else {
        // Add basic listener for new book
        pageController.addListener(_basicPageListener);
      }
    } catch (e) {
      debugPrint('Error in fetchData: $e');
    }
  }

  void _storedBookListener() {
    setState(() {
      page_no = pageController.page ?? 1;
      reviewUrl = reading[pageController.page!.toInt()].url ?? "";
    });
    Storage.instance.setReadingBookPage(page_no.toInt());
  }

  void _basicPageListener() {
    page_no = pageController.page ?? 1;
  }

  void showAds(int adCount) {
    if (adCount <= 0) return;
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
