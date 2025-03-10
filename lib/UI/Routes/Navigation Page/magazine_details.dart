import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';

// import 'package:flutter_html/style.dart';
// import 'package:flutter_screen_wake/flutter_screen_wake.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:search_page/search_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/book.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_chapter.dart';
import '../../../Model/reading_theme.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/app_storage.dart';
import '../../../Storage/data_provider.dart';
import '../../../Utility/ads_popup.dart';
import '../../../Utility/blockquote_extention.dart';
import '../../../Utility/embeded_link_extenion.dart';
import '../../../Utility/image_extension.dart';
import '../../../Utility/spaceExtension.dart';
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
  var themes = [
    ReadingTheme(
      Colors.black,
      Colors.white,
    ),
    ReadingTheme(
      Colors.white,
      Colors.black,
    ),
    ReadingTheme(
      Colors.black,
      Colors.grey.shade300,
    ),
    ReadingTheme(
      Colors.black,
      Colors.yellow.shade100,
    ),
  ];
  var list_bg_color = ['black', 'white', 'black', 'black'];
  var list_txt_color = ['white', 'black', '#e0e0e0', '#fff9be'];

  int selectedTheme = 0;
  double brightness = 0.0, page_no = 1;
  bool toggle = false;
  double sliderVal = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );
  List<BookWithAdsChapter> chapters = [];

  var _counterValue = 17.sp;

  var test = '''''', text = "";
  DynamicSize _dynamicSize = DynamicSizeImpl();
  SplittedText _splittedText = SplittedTextImpl();
  Size? _size;
  List<String> _splittedTextList = [];
  String reviewUrl = "";
  final GlobalKey pageKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    // removeScreenshotDisable();
  }

  getSizeFromBloc(GlobalKey pagekey) {
    _size = _dynamicSize.getSize(pagekey);
    print(_size);
  }

  getSplittedText(TextStyle textStyle, txt) {
    _splittedTextList = _splittedText.getSplittedText(_size!, textStyle, txt);
  }

  @override
  void initState() {
    super.initState();

    fetchBookDetails();
    // setScreenshotDisable();
    // initPlatformBrightness();
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
    // Future.delayed(Duration(seconds: 2), () {
    //   Navigation.instance.goBack();
    // });
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (e) {
      print(e);
      throw 'Failed to get system brightness';
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
      print('success');
    } catch (e) {
      print(e);
      throw 'Failed to set brightness';
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
            : Consumer<DataProvider>(builder: (context, data, _) {
                return chapters.isEmpty
                    ? Center(
                        child: Text(
                          bookDetails != null
                              ? ''
                              : 'Oops No Data available here',
                          style: TextStyle(
                              color: getBackGroundColor(), fontSize: 14.sp),
                        ),
                      )
                    : PageView.builder(
                        // shrinkWrap: true,
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: reading.length,
                        onPageChanged: (val) {
                          if (reading[val].viewAds ?? false) {
                            showAds(reading[val].ads_number);
                          } else {}
                        },
                        itemBuilder: (context, index) {
                          test = reading[index].desc ?? "";
                          reviewUrl = reading[index].url ?? "";
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showBottomSlider(reading.length);
                                  },
                                  child: Html(
                                    // data: test.trim(),
                                    data: test.trim(),
                                    // tagsList: [
                                    //   'img','p','!DOCTYPE html','body'
                                    // ],
                                    // tagsList: ['p'],
                                    // shrinkWrap: true,
                                    // customRender: {
                                    //   "table": (context, child) {
                                    //     return SingleChildScrollView(
                                    //       scrollDirection: Axis.horizontal,
                                    //       child: (context.tree
                                    //               as TableLayoutElement)
                                    //           .toWidget(context),
                                    //     );
                                    //   },
                                    //   "a": (context, child) {
                                    //     return GestureDetector(
                                    //       onTap: () {
                                    //         _launchUrl(Uri.parse(context
                                    //             .tree.attributes['href']
                                    //             .toString()));
                                    //         print(context
                                    //             .tree.attributes['href']);
                                    //       },
                                    //       child: Text(
                                    //         context.tree.element?.innerHtml
                                    //                 .split("=")[0]
                                    //                 .toString() ??
                                    //             "",
                                    //         style: Theme.of(Navigation
                                    //                 .instance
                                    //                 .navigatorKey
                                    //                 .currentContext!)
                                    //             .textTheme
                                    //             .headline5
                                    //             ?.copyWith(
                                    //               color: Colors.blue,
                                    //               fontWeight: FontWeight.bold,
                                    //               decoration:
                                    //                   TextDecoration.underline,
                                    //             ),
                                    //       ),
                                    //     );
                                    //   },
                                    // },
                                    style: {
                                      '#': Style(
                                        fontSize: FontSize(_counterValue),

                                        // maxLines: 20,
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
                                ),
                              ],
                            ),
                          );
                        },
                      );
              }),
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
                'https://tratri.in/link?format=${bookDetails?.book_format}&id=${bookDetails?.id}&details=$page&count=${widget.id.toString().split(",")[1]}&page=${pageController.page?.toInt()}');
          },
          icon: Icon(
            Icons.share,
            color: getTextColor(),
          ),
        ),
      ],
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      // title: Text('Welcome'),
      content: StatefulBuilder(builder: (context, _) {
        return SizedBox(
          // height: 20.h,
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
                                ?.copyWith(color: data.color1, fontSize: 17.sp),
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
                    ?.copyWith(color: getBackGroundColor(), fontSize: 15.sp),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              // StatefulBuilder(builder: (context, _) {
              //   return CounterButton(
              //     loading: false,
              //     onChange: (int val) {
              //       _(() {
              //         setState(() {
              //           _counterValue = val.toDouble();
              //           // _loadHtmlFromAssets(test, getBackGroundColor(),
              //           //     getTextColor(), _counterValue);
              //         });
              //       });
              //       setState(() {
              //         getSplittedText(
              //             TextStyle(
              //                 color: getBackGroundColor(),
              //                 fontSize: FontSize(_counterValue).size),
              //             text);
              //       });
              //     },
              //     count: _counterValue.toInt(),
              //     countColor: Colors.white,
              //     buttonColor: Colors.white,
              //     progressColor: Colors.white,
              //   );
              // }),
              ToggleSwitch(
                minWidth: 15.w,
                minHeight: 4.h,
                fontSize: 14.sp,
                initialLabelIndex: (_counterValue == 17.sp
                        ? 0
                        : _counterValue == 17.sp
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
              SizedBox(
                height: 1.h,
              ),
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

  void showBottomSlider(total) {
    showCupertinoModalBottomSheet(
      enableDrag: true,
      // expand: true,
      elevation: 15,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ConstanceData.secondaryColor.withOpacity(0.97),
      topRadius: const Radius.circular(15),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Material(
        child: StatefulBuilder(builder: (context, _) {
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
                      fontSize: 14.sp),
                ),
                Slider(
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
                      "Current: ${pageController.page}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                    ),
                    Text(
                      "Total: ${total}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
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

  handleClick(int item) {}

  void setScreenshotDisable() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void removeScreenshotDisable() async {
    // await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void fetchBookDetails() async {
    final response = await ApiProvider.instance
        .fetchBookDetails(widget.id.toString().split(',')[0]);
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {});
      }
    }
    final response1 = await ApiProvider.instance
        .fetchBookChaptersWithAds(widget.id.toString().split(',')[0] ?? '3');
    // .fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters ?? [];
      setState(() {
        reviewUrl = response1.chapters![0].review_url ?? "";
        debugPrint("ReviewUrl: $reviewUrl");
      });
      for (int i = 0; i < chapters.length; i++) {
        for (var j in chapters[i].pages!) {
          // if (i == int.parse(widget.id.toString().split(',')[1])) {
          //   reading.add(ReadingChapter(chapters[i].title, j));
          //   text = text + j;
          // }
          if (i >= int.parse(widget.id.toString().split(',')[1])) {
            reading.add(ReadingChapter(chapters[i].title, j.content,
                chapters[i].review_url, j.view_ad, j.view_ad_count));
            text = text + j.content!;
          }
        }
      }
      if (mounted) {
        setState(() {
          getSplittedText(
              TextStyle(
                  color: getBackGroundColor(),
                  fontSize: FontSize(_counterValue).value),
              text);
        });
      }
    }
    Navigation.instance.goBack();
  }

  void updateFont(val) {
    setState(() {
      _counterValue = val.toDouble();
      getSplittedText(
          TextStyle(
              color: getBackGroundColor(),
              fontSize: FontSize(_counterValue).value),
          text);
    });
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  void showAds(int? adCount) {
    if (adCount == null || adCount <= 0) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
          child: AdsPopup(
            adCount: adCount,
          ),
        );
      },
    );
  }
}
