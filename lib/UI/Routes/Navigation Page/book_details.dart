import 'dart:async';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Model/book_chapter.dart';
import 'package:ebook/Model/book_details.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:search_page/search_page.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/book.dart';

class BookDetails extends StatefulWidget {
  final int id;

  BookDetails(this.id);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  String background = "https://picsum.photos/id/237/200/300";
  var multiImageProvider = [
    "https://picsum.photos/id/1001/5616/3744",
    "https://picsum.photos/id/1003/1181/1772",
    "https://picsum.photos/id/1004/5616/3744",
    "https://picsum.photos/id/1005/5760/3840"
  ];
  BookDetailsModel? bookDetails;
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
      Colors.grey.shade600,
    ),
  ];
  int selectedTheme = 0;
  double brightness = 0.0;

  bool toggle = false;
  double sliderVal = 0;

  List<BookChapter>? chapters;

  @override
  void dispose() {
    super.dispose();
    removeScreenshotDisable();
  }

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
    setScreenshotDisable();
    // initPlatformBrightness();
    Future.delayed(Duration.zero, () async {
      brightness = await systemBrightness;
      Navigation.instance.navigate('/readingDialog');
    });
    Future.delayed(Duration(seconds: 2), () {
      Navigation.instance.goBack();
    });
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
      appBar: AppBar(
        title: Text(
          bookDetails?.title ?? "",
          style: Theme.of(context)
              .textTheme
              .headline5
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
            icon: const Icon(
              Icons.font_download,
            ),
          ),
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Create a Bookmark',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.bookmark),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Save for later',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
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
                    Icon(Icons.download),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Download',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.book),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Table of Contents',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Share',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.info),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'About Book',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
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
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            children: [
              SizedBox(
                height: 3.h,
                width: double.infinity,
                child: Container(
                    // color: Colors.blue,
                    ),
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) => setState(() {
                    currentIndex = index;
                    background = multiImageProvider[index];
                    sliderVal = index.toDouble();
                  }),
                  physics: const ClampingScrollPhysics(),
                  itemCount: chapters?.length,
                  itemBuilder: (context, index) {
                    return AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: currentIndex == index ? 1.0 : 0.1,
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          // height: 70.h,
                          decoration: BoxDecoration(
                            color: getBodyColor(),
                          ),
                          child: Container(
                            // color: Colors.black,
                            child: Html(
                              style: {

                              },
                              data:
                              "<p>But I must explain to you how all this mistaken idea of denouncing pleasure and praising "
                                  "pain was born and I will give you a complete account of the system, and expound the actual teachings"
                                  " of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes,"
                                  " or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue"
                                  " pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who"
                                  " loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally"
                                  " circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example"
                                  ", which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But "
                                  "who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences"
                                  ", or one who avoids a pain that produces no resultant pleasure?</p>\n\n<p>But I must explain to you how all"
                                  " this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account"
                                  " of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of"
                                  " human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because"
                                  " those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful."
                                  " Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but"
                                  " because occasionally circumstances occur in which toil and pain can procure him some great pleasure. "
                                  "To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain"
                                  " some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure"
                                  " that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?</p>\n\n"
                                  "\n\n<p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti "
                                  "atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident,"
                                  " similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et "
                                  "harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est"
                                  "eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas "
                                  "assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum "
                                  "necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque "
                                  "earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur "
                                  "aut perferendis doloribus asperiores repellat.</p>\n\n<p>At vero eos et accusamus et iusto odio dignissimos "
                                  "ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi "
                                  "sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.</p>",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  // print('dads');
                  showCupertinoModalBottomSheet(
                    enableDrag: true,
                    // expand: true,
                    elevation: 15,
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: Theme.of(context).accentColor,
                    topRadius: const Radius.circular(15),
                    closeProgressThreshold: 10,
                    context: Navigation.instance.navigatorKey.currentContext ??
                        context,
                    builder: (context) => Material(
                      color: getBodyColor(),
                      child: StatefulBuilder(builder: (context, update) {
                        return SizedBox(
                          height: 30.h,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                height: 15.h,
                                width: double.infinity,
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enjoying your free preview?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(color: getTextColor()),
                                    ),
                                    Text(
                                      "Keep reading with a free trial",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(color: getTextColor()),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 4.5.h,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigation.instance
                                                  .navigate('/bookInfo');
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue),
                                            ),
                                            child: Text(
                                              'Start Trial',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    fontSize: 3.h,
                                                    color: Colors.black,
                                                  ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 15.h,
                                width: double.infinity,
                                color: Colors.grey.shade900,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Slider(
                                            min: 0,
                                            max: double.parse(multiImageProvider
                                                .length
                                                .toString()),
                                            activeColor: Colors.blue,
                                            inactiveColor: Colors.white,
                                            onChanged: (double value) {
                                              update(() {
                                                setState(() {
                                                  sliderVal = value;
                                                  background =
                                                      multiImageProvider[
                                                          value.toInt()];
                                                });
                                              });
                                            },
                                            value: sliderVal,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showSearch(
                                              context: context,
                                              delegate: SearchPage<Book>(
                                                items:
                                                    ConstanceData.Motivational,
                                                searchLabel: 'Search people',
                                                suggestion: const Center(
                                                  child: Text(
                                                      'Filter people by name, surname or age'),
                                                ),
                                                failure: const Center(
                                                  child: Text(
                                                      'No person found :('),
                                                ),
                                                filter: (current) => [
                                                  current.name,
                                                  current.author,
                                                  // person.age.toString(),
                                                ],
                                                builder: (book) => ListTile(
                                                  title: Text(book.name ?? ''),
                                                  subtitle:
                                                      Text(book.author ?? ''),
                                                  trailing: CachedNetworkImage(
                                                    imageUrl: book.image ?? '',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.search),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${(multiImageProvider.length - sliderVal).toInt()} pages left in the chapter',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  fontSize: 2.h,
                                                  // color: Colors.black,
                                                ),
                                          ),
                                          Text(
                                            'page ${sliderVal.toInt() + 1} of ${multiImageProvider.length}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  fontSize: 2.h,
                                                  // color: Colors.black,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                },
                child: Container(
                  height: 30.h,
                  width: double.infinity,
                  color: getBodyColor(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      // title: Text('Welcome'),
      content: StatefulBuilder(builder: (context, _) {
        return SizedBox(
          height: 20.h,
          width: 50.w,
          child: Column(
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
      case 0:
        return themes[selectedTheme].color1;
      case 1:
        return themes[selectedTheme].color1;
      default:
        return Theme.of(context).accentColor;
    }
  }

  getTextColor() {
    switch (selectedTheme) {
      case 0:
        return themes[selectedTheme].color2;
      case 1:
        return themes[selectedTheme].color2;
      default:
        return Theme.of(context).textTheme.headline5?.color;
    }
  }

  getBodyColor() {
    switch (selectedTheme) {
      case 0:
        return themes[selectedTheme].color2;
      case 1:
        return themes[selectedTheme].color2;
      default:
        return Theme.of(context).textTheme.headline5?.color;
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
    final response =
        await ApiProvider.instance.fetchBookDetails(widget.id.toString());
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {});
      }
    }
    final response1 =
        await ApiProvider.instance.fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
