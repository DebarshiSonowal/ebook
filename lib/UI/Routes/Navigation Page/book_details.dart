import 'dart:async';
import 'dart:core';

import 'package:counter_button/counter_button.dart';
import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/reading_chapter.dart';
import '../../Components/dynamicSize.dart';
import '../../Components/splittedText.dart';

class BookDetails extends StatefulWidget {
  final int input;

  BookDetails(this.input);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  String title = '';

  // WebViewController? _controller;

  String background = "https://picsum.photos/id/237/200/300";

  BookDetailsModel? bookDetails;
  var themes = [
    ReadingTheme(
      Colors.white,
      Colors.black,
    ),
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
  ];
  var list_bg_color = ['black', 'white', 'black', 'black'];
  var list_txt_color = ['white', 'black', '#e0e0e0', '#fff9be'];
  List<String> pageText = [];
  int selectedTheme = 0;
  double brightness = 0.0;
  bool toggle = false;
  double sliderVal = 0;

  List<BookChapter> chapters = [];
  List<ReadingChapter> reading = [];
  String read = '';
  var _counterValue = 13.sp;

  var test = '''''';
  DynamicSize _dynamicSize = DynamicSizeImpl();
  SplittedText _splittedText = SplittedTextImpl();
  Size? _size;
  List<String> _splittedTextList = [];

  final GlobalKey pageKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();

    // removeScreenshotDisable();
  }

  // void _scrollListener() {
  //   // _firstAutoscrollExecuted = true;
  //
  //   if (_scrollController.hasClients &&
  //       _scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent) {
  //     // _shouldAutoscroll = true;
  //     // if ((currentPage + 1) >= (chapters[currentChapter].pages?.length ?? 0)) {
  //     //   // debugPrint(
  //     //   //     'first one ${currentPage} ${chapters[currentChapter].pages?.length}');
  //     //   // setState(() {
  //     //   //   currentChapter++;
  //     //   //   currentPage = 0;
  //     //   // });
  //     // }
  //   } else {
  //     // debugPrint(
  //     //     'second one ${currentPage} ${chapters[currentChapter].pages?.length}');
  //     // _shouldAutoscroll = false;
  //     // if (currentPage == 0) {
  //
  //     // }
  //   }
  // }

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
      Navigation.instance.navigate('/readingDialog');
      setState(() {
        Storage.instance
            .setReadingBook(int.parse(widget.input.toString().split(',')[0]));
      });
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
          PopupMenuButton<int>(
            color: getTextColor(),
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              // PopupMenuItem<int>(
              //   value: 0,
              //   child: Row(
              //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Icon(
              //         Icons.add,
              //         color: getBackGroundColor(),
              //       ),
              //       SizedBox(
              //         width: 5.w,
              //       ),
              //       Text(
              //         'Create a Bookmark',
              //         style: Theme.of(context).textTheme.headline5?.copyWith(
              //               color: getBackGroundColor(),
              //             ),
              //       ),
              //     ],
              //   ),
              // ),
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
          // IconButton(
          //   onPressed: () {
          //
          //   },
          //   icon: const Icon(
          //     FontAwesomeIcons.hamburger,
          //   ),
          // ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: getBodyColor(),
        key: pageKey,
        child: bookDetails == null
            ? const Center(child: CircularProgressIndicator())
            : Consumer<DataProvider>(builder: (context, data, _) {
                return chapters.isEmpty
                    ? const Center(
                        child: Text('Oops No Data available here'),
                      )
                    : PageView.builder(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: reading.length,
                        itemBuilder: (context, index) {
                          test = reading[index].desc!;
                          return GestureDetector(
                            onTap: () {
                              Navigation.instance.goBack();
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
                        // separatorBuilder: (BuildContext context, int index) {
                        //   var title = reading[index + 1].title;
                        //   return (index != 0 &&
                        //           (reading[index].title ==
                        //               reading[index - 1].title))
                        //       ? SizedBox(
                        //           width: 98.w,
                        //           height: double.infinity,
                        //           child: Center(
                        //             child: Text(
                        //               title!,
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .headline1
                        //                   ?.copyWith(
                        //                       color: getBackGroundColor()),
                        //             ),
                        //           ),
                        //         )
                        //       : Container();
                        // },
                      );
                // : PageView.builder(
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     physics: const ClampingScrollPhysics(),
                //     itemCount: _splittedTextList.length,
                //     itemBuilder: (context, index) {
                //       test = _splittedTextList[index] ?? "";
                //       return Container(
                //         width: 100.w,
                //         // height: 90.h,
                //         padding: EdgeInsets.symmetric(
                //           horizontal: 5.w,
                //         ),
                //         color: getTextColor(),
                //         // child: Text.rich(
                //         //   TextSpan(
                //         //     text: test,
                //         //   ),
                //         //   style: TextStyle(
                //         //     color: getBackGroundColor(),
                //         //     fontSize: FontSize(_counterValue).size,
                //         //   ),
                //         // ),
                //         child: Html(
                //           data: test,
                //           // tagsList: [
                //           //   'img','p','!DOCTYPE html','body'
                //           // ],
                //           // tagsList: ['p'],
                //           // shrinkWrap: true,
                //           style: {
                //             '#': Style(
                //               fontSize: FontSize(_counterValue),
                //
                //               maxLines: FontSize(_counterValue)
                //                   .size!
                //                   .toInt()
                //                   .sp
                //                   .toInt(),
                //               color: getBackGroundColor(),
                //               // textOverflow: TextOverflow.ellipsis,
                //             ),
                //           },
                //         ),
                //       );
                //     },
                //   );
              }),
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.color1,
                            border: Border.all(
                                color: selectedTheme == index
                                    ? Colors.blue
                                    : data.color1!)),
                        height: 5.h,
                        width: 10.w,
                        child: Center(
                          child: Text(
                            'Aa',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: data.color2),
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
                    .headline5
                    ?.copyWith(color: getTextColor()),
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
                fontSize: 12.sp,
                initialLabelIndex: (_counterValue==13.sp?0:_counterValue==17.sp?1:2)??0,
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
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: getTextColor()),
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
}
