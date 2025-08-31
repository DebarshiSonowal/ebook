import 'package:counter_button/counter_button.dart';
import 'package:ebook/Storage/data_provider.dart';
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

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_theme.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/app_storage.dart';
import '../../../Utility/blockquote_extention.dart';
import '../../../Utility/embeded_link_extenion.dart';
import '../../../Utility/image_extension.dart';
import '../../../Utility/spaceExtension.dart';

class ReadingPage extends StatefulWidget {
  final int id;

  ReadingPage(this.id);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
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
  Book? bookDetails;
  bool canShare = false;

  var _counterValue = 12.sp;
  int selectedTheme = 0;
  double brightness_lvl = 1, page_no = 1;
  bool toggle = false;
  double sliderVal = 0; 
  String title = '';
  List<BookWithAdsChapter> chapters = [];
  PageController pageController = PageController(
    initialPage: 0,
  );

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
      if (mounted) {
        setState(() {
          Storage.instance.setReadingBook(widget.id);
        });
      }
    });
    pageController.addListener(() {
      if (mounted) {
        setState(() {
          page_no = pageController.page ?? 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: getTextColor()),
        title: Text(
          title.isNotEmpty ? title : "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: getTextColor(), fontSize: 14.sp),
        ),
        backgroundColor: getBackGroundColor(),
        actions: [
          IconButton(
            onPressed: () {
              if (context != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return buildAlertDialog();
                  },
                );
              }
            },
            icon: Icon(
              Icons.font_download,
              color: getTextColor(),
            ),
          ),
          canShare
              ? IconButton(
                  onPressed: () async {
                    try {
                      String page = "reading";
                      final shareUrl =
                          'https://tratri.in/link?format=${Uri.encodeComponent(bookDetails?.book_format ?? '')}&id=${bookDetails?.id}&details=$page&page=${pageController.page?.toInt()}&image=${Uri.encodeComponent(bookDetails?.profile_pic ?? '')}';

                      await Share.share(shareUrl);
                    } catch (e) {
                      debugPrint('Error sharing: $e');
                    }
                  },
                  icon: Icon(
                    Icons.share,
                    color: getTextColor(),
                  ),
                )
              : Container(),
          PopupMenuButton<int>(
            color: getTextColor(),
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: getBackGroundColor(),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Add bookmark',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: getBackGroundColor(),
                              ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.close,
                      color: getBackGroundColor(),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Finished',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: getBackGroundColor(),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: getBodyColor(),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.isNotEmpty ? title : "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: getBackGroundColor()),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  const Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 70.h,
                width: double.infinity,
                child: chapters.isNotEmpty
                    ? PageView.builder(
                        controller: pageController,
                        itemBuilder: (cont, index) {
                          if (index >= chapters.length) return Container();
                          BookWithAdsChapter current = chapters[index];
                          return GestureDetector(
                            onTap: () {
                              if (widget.id != null && data.details != null) {
                                Navigation.instance.navigate('/bookDetails',
                                    args:
                                        '${widget.id},${data.details?.profile_pic}');
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.blue,
                              )),
                              height: 60.h,
                              width: 50.w,
                              child: Html(
                                data: current.pages?.isNotEmpty == true
                                    ? current.pages![0].content ?? ""
                                    : "",
                                shrinkWrap: true,
                                style: {
                                  '#': Style(
                                    fontSize: FontSize(_counterValue),
                                    maxLines: 5,
                                    color: getBackGroundColor(),
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
                          );
                        },
                        itemCount: chapters.length,
                        onPageChanged: (count) {
                          if (mounted) {
                            setState(() {
                              brightness_lvl = count.toDouble();
                            });
                          }
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "chapter ${brightness_lvl.toInt() + 1} of ${chapters.length}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: getBackGroundColor()),
              ),
              SizedBox(
                height: 1.h,
              ),
              if (chapters.isNotEmpty)
                Slider(
                  value: brightness_lvl,
                  min: 0,
                  max: chapters.isNotEmpty
                      ? (chapters.length - 1).toDouble()
                      : 0,
                  onChanged: (value) {
                    if (value != null) {
                      if (mounted) {
                        setState(() {
                          brightness_lvl = value;
                        });
                      }
                      if (chapters.isNotEmpty) {
                        pageController.jumpToPage(brightness_lvl.toInt());
                      }
                    }
                  },
                ),
            ],
          );
        }),
      ),
    );
  }

  void fetchBookDetails() async {
    // Make parallel API calls
    final futures = await Future.wait([
      ApiProvider.instance.fetchBookDetails(widget.id.toString()),
      ApiProvider.instance.fetchBookChaptersWithAds(widget.id.toString()),
    ]);

    // Handle book details response
    final bookResponse = futures[0] as BookDetailsResponse;
    if (bookResponse.status == true) {
      bookDetails = bookResponse.details;
      canShare = bookDetails?.status == 2; // Check book details status
      if (mounted) {
        setState(() {
          title = bookDetails?.title ?? "";
        });
      }
    }

    // Handle chapters response
    final chaptersResponse = futures[1] as BookChapterWithAdsResponse;
    if (chaptersResponse.status == true) {
      chapters = chaptersResponse.chapters ?? [];
      if (mounted) {
        setState(() {});
      }
    }

    if (Navigation.instance != null) {
      Navigation.instance.goBack();
    }
  }

  getBackGroundColor() {
    if (themes.isNotEmpty) {
      switch (selectedTheme) {
        default:
          return themes[selectedTheme].color1;
      }
    }
    return Colors.white;
  }

  getTextColor() {
    if (themes.isNotEmpty) {
      switch (selectedTheme) {
        default:
          return themes[selectedTheme].color2;
      }
    }
    return Colors.black;
  }

  getBodyColor() {
    if (themes.isNotEmpty) {
      switch (selectedTheme) {
        default:
          return themes[selectedTheme].color2;
      }
    }
    return Colors.white;
  }

  handleClick(int item) {}

  void setScreenshotDisable() async {}

  void removeScreenshotDisable() async {}

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      content: StatefulBuilder(builder: (context, _) {
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
                    ?.copyWith(color: getBackGroundColor(), fontSize: 13.sp),
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
                    if (themes.isNotEmpty) {
                      var data = themes[index];
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              selectedTheme = index;
                            });
                          }
                        },
                        child: ThemeItem(
                          data: data,
                          selectedTheme: selectedTheme,
                          index: index,
                        ),
                      );
                    } else {
                      return Container();
                    }
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
                    ?.copyWith(color: getBackGroundColor(), fontSize: 13.sp),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              StatefulBuilder(builder: (context, _) {
                return CounterButton(
                  loading: false,
                  onChange: (int val) {
                    if (mounted) {
                      setState(() {
                        _counterValue = val.toDouble();
                      });
                    }
                  },
                  count: _counterValue.toInt(),
                  countColor: Colors.white,
                  buttonColor: Colors.white,
                  progressColor: Colors.white,
                );
              }),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Brightness",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: getBackGroundColor(), fontSize: 13.sp),
              ),
              Slider(
                  value: brightness_lvl,
                  onChanged: (value) {
                    if (value != null) {
                      ScreenBrightness().setScreenBrightness(value);
                      if (mounted) {
                        setState(() {
                          brightness_lvl = value;
                        });
                      }
                      if (brightness_lvl == 0) {
                        toggle = true;
                      } else {
                        toggle = false;
                      }
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
    if (Navigation.instance != null) {
      showCupertinoModalBottomSheet(
        enableDrag: true,
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
                          fontSize: 14.sp,
                        ),
                  ),
                  Slider(
                    value: page_no,
                    onChanged: (value) {
                      if (value != null) {
                        _(() {
                          page_no = value;
                          pageController.jumpToPage(
                            page_no.toInt(),
                          );
                        });
                        if (mounted) {
                          setState(() {});
                        }

                        if (page_no == 0) {
                          toggle = true;
                        } else {
                          toggle = false;
                        }
                      }
                    },
                    max: total.toDouble(),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current: ${page_no.toInt()}",
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
                        "Total: ${total}",
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
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (e) {
      print(e);
      throw 'Failed to get system brightness';
    }
  }
}

class ThemeItem extends StatelessWidget {
  const ThemeItem({
    Key? key,
    required this.data,
    required this.selectedTheme,
    required this.index,
  }) : super(key: key);

  final ReadingTheme data;
  final int selectedTheme, index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: data.color2,
          border: Border.all(
              color: selectedTheme == index
                  ? Colors.blue
                  : data.color2 ?? Colors.transparent)),
      height: 5.h,
      width: 10.w,
      child: Center(
        child: Text(
          "Aa",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: data.color1, fontSize: 13.sp),
        ),
      ),
    );
  }
}
