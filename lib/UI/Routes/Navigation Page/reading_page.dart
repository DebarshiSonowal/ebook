import 'dart:convert';

import 'package:counter_button/counter_button.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Model/reading_theme.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/app_storage.dart';

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
  BookDetailsModel? bookDetails;
  var list_bg_color = ['black', 'white', 'black', 'black'];
  var list_txt_color = ['white', 'black', '#e0e0e0', '#fff9be'];
  var _counterValue = 12.sp;
  int selectedTheme = 0;
  double page_no = 1;
  bool toggle = false;
  double sliderVal = 0;
  String title = '';
  List<BookChapter> chapters = [];
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    super.dispose();

    // removeScreenshotDisable();
  }

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(_scrollListener);
    fetchBookDetails();
    // setScreenshotDisable();
    // initPlatformBrightness();
    Future.delayed(Duration.zero, () async {
      // page_no = await systemBrightness;
      Navigation.instance.navigate('/readingDialog');
      setState(() {
        Storage.instance.setReadingBook(widget.id);
      });
    });
    // pageController.addListener(() {
    //   print(pageController.page??0);
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: getTextColor()),
        title: Text(
          title ?? "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: getTextColor()),
        ),
        backgroundColor: getBackGroundColor(),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildAlertDialog();
                },
              );
            },
            icon: Icon(
              Icons.font_download,
              color: getTextColor(),
            ),
          ),
          PopupMenuButton<int>(
            color: getTextColor(),
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: getBackGroundColor(),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Add bookmark',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: getBackGroundColor(),
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.close,
                      color: getBackGroundColor(),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Finished',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
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
                    title ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
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
                child: PageView.builder(
                  controller: pageController,
                  itemBuilder: (cont, index) {
                    var current = chapters[index];

                    return GestureDetector(
                      onTap: () {
                        Navigation.instance.navigate('/bookDetails',
                            args: '${widget.id},${index}');
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
                          data: current.pages![0],

                          // tagsList: [
                          //   'img','p','!DOCTYPE html','body'
                          // ],
                          // tagsList: ['p'],
                          shrinkWrap: true,
                          style: {
                            '#': Style(
                              fontSize: FontSize(_counterValue),
                              maxLines: 5,
                              color: getBackGroundColor(),
                              // textOverflow: TextOverflow.ellipsis,
                            ),
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: chapters.length,
                  onPageChanged: (count) {
                    setState(() {
                      page_no = count.toDouble();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "chapter ${page_no.toInt() + 1} of ${chapters.length}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: getBackGroundColor()),
              ),
              SizedBox(
                height: 1.h,
              ),
              Slider(
                  value: page_no,
                  min: 0,
                  max: double.parse((chapters.length ?? 0).toString()),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      page_no = value.toInt().toDouble();
                    });
                    pageController.jumpToPage(page_no.toInt());
                  }),
            ],
          );
        }),
      ),
    );
  }

  void fetchBookDetails() async {
    final response =
        await ApiProvider.instance.fetchBookDetails(widget.id.toString());
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {
          title = bookDetails?.title ?? "";
        });
      }
    }
    final response1 = await ApiProvider.instance
        .fetchBookChapters(widget.id.toString() ?? '3');
    // .fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters ?? [];
      if (mounted) {
        setState(() {});
      }
    }
    Navigation.instance.goBack();
  }

  getBackGroundColor() {
    switch (selectedTheme) {
      default:
        return themes[selectedTheme].color1;
    }
  }

  getTextColor() {
    switch (selectedTheme) {
      default:
        return themes[selectedTheme].color2;
    }
  }

  getBodyColor() {
    switch (selectedTheme) {
      default:
        return themes[selectedTheme].color2;
    }
  }

  handleClick(int item) {}

  void setScreenshotDisable() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void removeScreenshotDisable() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
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
                    .headline5
                    ?.copyWith(color: getTextColor()),
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
                      child: ThemeItem(
                        data: data,
                        selectedTheme: selectedTheme,
                        index: index,
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
                    .headline5
                    ?.copyWith(color: getTextColor()),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              StatefulBuilder(builder: (context, _) {
                return CounterButton(
                  loading: false,
                  onChange: (int val) {
                    _(() {
                      setState(() {
                        _counterValue = val.toDouble();
                        // _loadHtmlFromAssets(test, getBackGroundColor(),
                        //     getTextColor(), _counterValue);
                      });
                    });
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
                    .headline5
                    ?.copyWith(color: getTextColor()),
              ),
              Slider(
                  value: page_no,
                  onChanged: (value) {
                    _(() {
                      setState(() {
                        page_no = value;
                        FlutterScreenWake.setBrightness(page_no);
                      });
                      // setBrightness(value);
                    });

                    if (page_no == 0) {
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
              color: selectedTheme == index ? Colors.blue : data.color2!)),
      height: 5.h,
      width: 10.w,
      child: Center(
        child: Text(
          'Aa',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: data.color1),
        ),
      ),
    );
  }
}
