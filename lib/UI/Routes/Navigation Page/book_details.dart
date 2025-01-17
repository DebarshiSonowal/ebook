import 'dart:async';
import 'dart:core';

import 'package:counter_button/counter_button.dart';
import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Utility/blockquote_extention.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
// import 'package:flutter_screen_wake/flutter_screen_wake.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
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
  Book? bookDetails;
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
  List<BookChapter> chapters = [];
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
                IconButton(
                  onPressed: () {
                    // Share.share(
                    //     'https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook');
                    String page = "reading";
                    Share.share(
                        'https://tratri.in/link?format=${bookDetails?.book_format}&id=${bookDetails?.id}&details=$page&page=${pageController.page?.toInt()}&image=${bookDetails?.profile_pic}');
                  },
                  icon: Icon(
                    Icons.share,
                    color: getTextColor(),
                  ),
                ),
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
                    _(() {
                      setState(() {
                        brightness = value;
                        // FlutterScreenWake.setBrightness(brightness);
                      });
                      // setBrightness(value);
                    });

                    if (brightness == 0) {
                      toggle = true;
                    } else {
                      toggle = false;
                    }
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
    final response = await ApiProvider.instance
        .fetchBookDetails(widget.input.toString().split(',')[0].toString());
    if (response.status ?? false) {
      if (response.details?.flip_book_url?.isNotEmpty ?? true) {
        _launchUrl(response.details?.flip_book_url);
      }
      bookDetails = response.details;

      if (mounted) {
        setState(() {
          title = bookDetails?.title ?? "";
        });
      }
    }
    final response1 = await ApiProvider.instance
        .fetchBookChapters(widget.input.toString().split(',')[0] ?? '3');
    // .fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters ?? [];
      setState(() {
        reviewUrl = response1.chapters![0].review_url ?? "";
        debugPrint("ReviewUrl: $reviewUrl");
      });
      for (var i in chapters) {
        for (var j in i.pages!) {
          reading.add(ReadingChapter('', j, i.review_url));
          read = read + j;
        }
      }

      if (mounted) {
        setState(() {
          getSplitedText(
              TextStyle(
                  color: getBackGroundColor(),
                  fontSize: FontSize(_counterValue).value),
              read);
          // setPages(FontSize(_counterValue).size?.toInt());
        });
      }
    }
    Navigation.instance.goBack();
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
    if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  void fetchData() async {
    // print("here we are");
    Navigation.instance.navigate('/readingDialog',
        args: widget.input.toString().split(',')[1]);
    await fetchBookDetails();
    // print("here we are");
    Future.delayed(Duration.zero, () async {
      brightness = await systemBrightness;
      getSizeFromBloc(pageKey);

      setState(() {
        Storage.instance
            .setReadingBook(int.parse(widget.input.toString().split(',')[0]));
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint(
          "Executed ${Storage.instance.readingBook} ${widget.input.toString().split(',')[0]}");
      if (Storage.instance.readingBook.toString() ==
          widget.input.toString().split(',')[0].toString()) {
        debugPrint("Scroll ${Storage.instance.readingBookPage}");
        pageController.jumpToPage(Storage.instance.readingBookPage);
        pageController.addListener(() {
          setState(() {
            page_no = pageController.page ?? 1;
            reviewUrl = reading[pageController.page!.toInt()].url ?? "";
          });
          Storage.instance.setReadingBookPage(page_no.toInt());
        });
      } else {
        pageController.addListener(() {
          page_no = pageController.page ?? 1;
        });
      }
      // Navigation.instance.goBack();
    });
  }
}
