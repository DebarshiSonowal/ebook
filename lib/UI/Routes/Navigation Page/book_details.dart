import 'package:awesome_icons/awesome_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Model/reading_theme.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';

class BookDetails extends StatefulWidget {
  final int index;

  BookDetails(this.index);

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

  double sliderVal=0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ConstanceData.bestselling[widget.index].name ?? "",
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: getTextColor()),
        ),
        backgroundColor: getBackGroundColor(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.font_download,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.hamburger,
              )),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: getBodyColor(),
        child: Column(
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
                }),
                physics: const ClampingScrollPhysics(),
                itemCount: multiImageProvider.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: currentIndex == index ? 1.0 : 0.1,
                    child: GestureDetector(
                      onTap: () {
                        showImageViewerPager(
                            context,
                            MultiImageProvider([
                              Image.network(background).image,
                            ]),
                            onPageChanged: (page) {
                              print("page changed to $page");
                            },
                            backgroundColor: getBodyColor(),
                            closeButtonColor: Colors.black,
                            onViewerDismissed: (page) {
                              print("dismissed while on page $page");
                            });
                      },
                      child: Container(
                        // height: 70.h,
                        decoration: BoxDecoration(
                          color: getBodyColor(),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: background,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                print('dads');
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
                  builder: (context) =>  Material(
                    color: getBodyColor(),
                    child: Container(
                      height: 40.h,
                      width: double.infinity,

                      child: Column(
                        children: [
                          Container(
                            height: 20.h,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                          Container(
                            height: 20.h,
                            width: double.infinity,
                            color: Colors.grey.shade900,
                            child: Slider(
                              activeColor: Colors.blue,
                              inactiveColor: Colors.white,
                              onChanged: (double value) {
                                setState((){
                                  sliderVal=value;
                                });
                              },
                              value: sliderVal,
                            ),
                          ),
                        ],
                      ),
                    ),
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
        ),
      ),
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
}
