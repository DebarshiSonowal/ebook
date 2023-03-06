import 'dart:async';
import 'dart:core';

import 'package:counter_button/counter_button.dart';
import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/reading_chapter.dart';
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
      Colors.grey.shade300,
    ),
    ReadingTheme(
      Colors.black,
      Colors.yellow.shade100,
    ),
    ReadingTheme(
      Colors.black,
      Colors.white,
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
  String read = '';
  var _counterValue = 13.sp;
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

    // _scrollController.addListener(_scrollListener);
    fetchBookDetails();
    // setScreenshotDisable();
    // initPlatformBrightness();
    Future.delayed(Duration.zero, () async {
      brightness = await systemBrightness;
      getSizeFromBloc(pageKey);
      Navigation.instance.navigate('/readingDialog',
          args: widget.input.toString().split(',')[1]);
      setState(() {
        Storage.instance
            .setReadingBook(int.parse(widget.input.toString().split(',')[0]));
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      print(
          "Executed ${Storage.instance.readingBook} ${widget.input.toString().split(',')[0]}");
      if (Storage.instance.readingBook.toString() ==
          widget.input.toString().split(',')[0].toString()) {
        print("Scroll ${Storage.instance.readingBookPage}");
        pageController.jumpToPage(Storage.instance.readingBookPage);
        pageController.addListener(() {
          page_no = pageController.page ?? 1;
          if (Storage.instance.readingBook.toString() ==
              widget.input.toString().split(',')[0].toString()) {
            Storage.instance.setReadingBookPage(page_no.toInt());
          }
        });
      } else {
        pageController.addListener(() {
          page_no = pageController.page ?? 1;
          // if(Storage.instance.readingBook.toString()==widget.input.toString().split(',')[0].toString()){
          //   Storage.instance.setReadingBookPage(page_no.toInt());
          // }
        });
      }
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
                IconButton(
                  onPressed: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook');
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
                                        // tagsList: [
                                        //   'img','p','!DOCTYPE html','body'
                                        // ],
                                        // tagsList: ['p'],
                                        // shrinkWrap: true,
                                        style: {
                                          '#': Style(
                                            fontSize: FontSize(_counterValue),

                                            // maxLines: 20,
                                            color: getBackGroundColor(),
                                            // textOverflow: TextOverflow.ellipsis,
                                          ),
                                        },
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
          // height: 20.h,
          width: 50.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Theme",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: getBackGroundColor(),
                    ),
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
                                .headline5
                                ?.copyWith(color: data.color1),
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
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: getBackGroundColor(),
                    ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              ToggleSwitch(
                minWidth: 15.w,
                minHeight: 4.h,
                fontSize: 12.sp,
                initialLabelIndex: (_counterValue == 13.sp
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
                labels: ['13', '17', '20'],
                onToggle: (index) {
                  switch (index) {
                    case 1:
                      updateFont(17.sp);
                      break;
                    case 2:
                      updateFont(20.sp);
                      break;
                    default:
                      updateFont(13.sp);
                  }
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Brightness",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: getBackGroundColor(),
                    ),
              ),
              Slider(
                  value: brightness,
                  onChanged: (value) {
                    _(() {
                      setState(() {
                        brightness = value;
                        FlutterScreenWake.setBrightness(brightness);
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

  handleClick(int item) {}

  void setScreenshotDisable() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void removeScreenshotDisable() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void fetchBookDetails() async {
    final response = await ApiProvider.instance
        .fetchBookDetails(widget.input.toString().split(',')[0].toString());
    if (response.status ?? false) {
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
      for (var i in chapters) {
        for (var j in i.pages!) {
          reading.add(ReadingChapter('', j));
          read = read + j;
        }
      }

      if (mounted) {
        setState(() {
          getSplittedText(
              TextStyle(
                  color: getBackGroundColor(),
                  fontSize: FontSize(_counterValue).size),
              read);
          // setPages(FontSize(_counterValue).size?.toInt());
        });
      }
    }
    Navigation.instance.goBack();
  }

  getSizeFromBloc(GlobalKey pagekey) {
    _size = _dynamicSize.getSize(pagekey);
    print(_size);
  }

  void updateFont(val) {
    setState(() {
      _counterValue = val.toDouble();
      getSplittedText(
          TextStyle(
              color: getBackGroundColor(),
              fontSize: FontSize(_counterValue).size),
          read);
    });
  }

  getSplittedText(TextStyle textStyle, txt) {
    _splittedTextList = _splittedText.getSplittedText(_size!, textStyle, txt);
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
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Slider(
                  value: page_no,
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
                      "Current: ${page_no.toInt()}",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      "Total: ${total}",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
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
