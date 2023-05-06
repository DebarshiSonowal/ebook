import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
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
  List<BookChapter> chapters = [];

  var _counterValue = 11.sp;

  var test = '''''', text = "";
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
                          test = reading[index].desc ?? "";
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showBottomSlider(reading.length);
                                  },
                                  child: Html(
                                    data: test.trim(),
                                    // tagsList: [
                                    //   'img','p','!DOCTYPE html','body'
                                    // ],
                                    // tagsList: ['p'],
                                    // shrinkWrap: true,
                                    customRender: {
                                      "table": (context, child) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: (context.tree
                                                  as TableLayoutElement)
                                              .toWidget(context),
                                        );
                                      },
                                      "a": (context, child) {
                                        return GestureDetector(
                                          onTap: () {
                                            _launchUrl(Uri.parse(context
                                                .tree.attributes['href']
                                                .toString()));
                                            print(context
                                                .tree.attributes['href']);
                                          },
                                          child: Text(
                                            context.tree.element?.innerHtml
                                                    .split("=")[0]
                                                    .toString() ??
                                                "",
                                            style: Theme.of(Navigation
                                                    .instance
                                                    .navigatorKey
                                                    .currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  // color: Constance.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        );
                                      },
                                    },
                                    style: {
                                      '#': Style(
                                        fontSize: FontSize(_counterValue),

                                        // maxLines: 20,
                                        color: getBackGroundColor(),
                                        // textOverflow: TextOverflow.ellipsis,
                                      ),
                                    },
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
        // PopupMenuButton<int>(
        //   color: getTextColor(),
        //   onSelected: (item) => handleClick(item),
        //   itemBuilder: (context) => [
        //     PopupMenuItem<int>(
        //       value: 0,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(
        //             Icons.add,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'Create a Bookmark',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<int>(
        //       value: 1,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(
        //             Icons.bookmark,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'Save for later',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<int>(
        //       value: 2,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           Icon(
        //             Icons.download,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'Download',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<int>(
        //       value: 3,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(
        //             Icons.book,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'Table of Contents',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<int>(
        //       value: 4,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(
        //             Icons.share,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'Share',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<int>(
        //       value: 4,
        //       child: Row(
        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(
        //             Icons.info,
        //             color: getBackGroundColor(),
        //           ),
        //           SizedBox(
        //             width: 5.w,
        //           ),
        //           Text(
        //             'About Book',
        //             style: Theme.of(context).textTheme.headline5?.copyWith(
        //                   color: getBackGroundColor(),
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
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
                fontSize: 12.sp,
                initialLabelIndex: (_counterValue == 11.sp
                        ? 0
                        : _counterValue == 14.sp
                            ? 1
                            : 2) ??
                    0,
                activeBgColor: [Colors.black87],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.grey[900],
                totalSwitches: 3,
                labels: ['11', '14', '17'],
                onToggle: (index) {
                  switch (index) {
                    case 1:
                      updateFont(14.sp);
                      break;
                    case 2:
                      updateFont(17.sp);
                      break;
                    default:
                      updateFont(11.sp);
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
        .fetchBookDetails(widget.id.toString().split(',')[0]);
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {});
      }
    }
    final response1 = await ApiProvider.instance
        .fetchBookChapters(widget.id.toString().split(',')[0] ?? '3');
    // .fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters ?? [];
      for (int i = 0; i < chapters.length; i++) {
        for (var j in chapters[i].pages!) {
          // if (i == int.parse(widget.id.toString().split(',')[1])) {
          //   reading.add(ReadingChapter(chapters[i].title, j));
          //   text = text + j;
          // }
          if (i >= int.parse(widget.id.toString().split(',')[1])) {
            reading.add(ReadingChapter(chapters[i].title, j));
            text = text + j;
          }
        }
      }
      if (mounted) {
        setState(() {
          getSplittedText(
              TextStyle(
                  color: getBackGroundColor(),
                  fontSize: FontSize(_counterValue).size),
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
              fontSize: FontSize(_counterValue).size),
          text);
    });
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }
//  GestureDetector(
//                 onTap: () {
//                   // print('dads');
//                   showCupertinoModalBottomSheet(
//                     enableDrag: true,
//                     // expand: true,
//                     elevation: 15,
//                     clipBehavior: Clip.antiAlias,
//                     backgroundColor:
//                     Theme.of(context).accentColor,
//                     topRadius: const Radius.circular(15),
//                     closeProgressThreshold: 10,
//                     context: Navigation.instance.navigatorKey
//                         .currentContext ??
//                         context,
//                     builder: (context) => Material(
//                       color: getBodyColor(),
//                       child: StatefulBuilder(
//                           builder: (context, update) {
//                             return SizedBox(
//                               height: 30.h,
//                               width: double.infinity,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 15.h,
//                                     width: double.infinity,
//                                     color: Colors.black,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Enjoying your free preview?",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline5
//                                               ?.copyWith(
//                                             color:
//                                             getTextColor(),
//                                           ),
//                                         ),
//                                         Text(
//                                           "Keep reading with a free trial",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline5
//                                               ?.copyWith(
//                                             color:
//                                             getTextColor(),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 1.h,
//                                         ),
//                                         SizedBox(
//                                           width: double.infinity,
//                                           height: 4.5.h,
//                                           child: Padding(
//                                             padding:
//                                             const EdgeInsets
//                                                 .symmetric(
//                                                 horizontal:
//                                                 20.0),
//                                             child: ElevatedButton(
//                                                 onPressed: () {
//                                                   Navigation
//                                                       .instance
//                                                       .navigate(
//                                                       '/bookInfo');
//                                                 },
//                                                 style: ButtonStyle(
//                                                   backgroundColor:
//                                                   MaterialStateProperty
//                                                       .all(Colors
//                                                       .blue),
//                                                 ),
//                                                 child: Text(
//                                                   'Buy Now',
//                                                   style: Theme.of(
//                                                       context)
//                                                       .textTheme
//                                                       .headline5
//                                                       ?.copyWith(
//                                                     fontSize:
//                                                     3.h,
//                                                     color: Colors
//                                                         .black,
//                                                   ),
//                                                 )),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 15.h,
//                                     width: double.infinity,
//                                     color: Colors.grey.shade900,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: Slider(
//                                                 min: 0,
//                                                 max: double.parse(
//                                                     multiImageProvider
//                                                         .length
//                                                         .toString()),
//                                                 activeColor:
//                                                 Colors.blue,
//                                                 inactiveColor:
//                                                 Colors.white,
//                                                 onChanged:
//                                                     (double value) {
//                                                   update(() {
//                                                     setState(() {
//                                                       sliderVal =
//                                                           value;
//                                                       background =
//                                                       multiImageProvider[
//                                                       value
//                                                           .toInt()];
//                                                     });
//                                                   });
//                                                 },
//                                                 value: sliderVal,
//                                               ),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 showSearch(
//                                                   context: context,
//                                                   delegate:
//                                                   SearchPage<
//                                                       Book_old>(
//                                                     items: ConstanceData
//                                                         .Motivational,
//                                                     searchLabel:
//                                                     'Search people',
//                                                     suggestion:
//                                                     const Center(
//                                                       child: Text(
//                                                           'Filter people by name, surname or age'),
//                                                     ),
//                                                     failure:
//                                                     const Center(
//                                                       child: Text(
//                                                           'No person found :('),
//                                                     ),
//                                                     filter:
//                                                         (current) =>
//                                                     [
//                                                       current.name,
//                                                       current
//                                                           .author,
//                                                       // person.age.toString(),
//                                                     ],
//                                                     builder:
//                                                         (book) =>
//                                                         ListTile(
//                                                           title: Text(
//                                                               book.name ??
//                                                                   ''),
//                                                           subtitle: Text(
//                                                               book.author ??
//                                                                   ''),
//                                                           trailing:
//                                                           CachedNetworkImage(
//                                                             imageUrl:
//                                                             book.image ??
//                                                                 '',
//                                                             height: 20,
//                                                             width: 20,
//                                                           ),
//                                                         ),
//                                                   ),
//                                                 );
//                                               },
//                                               icon: Icon(
//                                                   Icons.search),
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 1.h,
//                                         ),
//                                         Container(
//                                           padding: const EdgeInsets
//                                               .symmetric(
//                                               horizontal: 20.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment
//                                                 .spaceBetween,
//                                             children: [
//                                               Text(
//                                                 '${(multiImageProvider.length - sliderVal).toInt()} pages left in the chapter',
//                                                 style: Theme.of(
//                                                     context)
//                                                     .textTheme
//                                                     .headline5
//                                                     ?.copyWith(
//                                                   fontSize: 2.h,
//                                                   // color: Colors.black,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 'page ${sliderVal.toInt() + 1} of ${multiImageProvider.length}',
//                                                 style: Theme.of(
//                                                     context)
//                                                     .textTheme
//                                                     .headline5
//                                                     ?.copyWith(
//                                                   fontSize: 2.h,
//                                                   // color: Colors.black,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 4.h,
//                   width: double.infinity,
//                   color: getBodyColor(),
//                 ),
//               ),
}
