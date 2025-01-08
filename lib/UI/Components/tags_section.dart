import 'package:ebook/Model/enote_banner.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/bookmark.dart';
import '../../Model/home_banner.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({Key? key, required this.data}) : super(key: key);
  final Book data;

  @override
  Widget build(BuildContext context) {
    return (data.tags?.isEmpty ?? true)
        ? Container()
        : SizedBox(
            width: 70.w,
            height: 3.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in data.tags ?? [])
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.goBack();
                            Navigation.instance
                                .navigate('/searchWithTag', args: i.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              i.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 13.sp,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class TagsSectionBookmark extends StatelessWidget {
  const TagsSectionBookmark({Key? key, required this.data}) : super(key: key);
  final BookmarkItem data;

  @override
  Widget build(BuildContext context) {
    return (data.tags?.isEmpty ?? true)
        ? Container()
        : SizedBox(
            width: 70.w,
            height: 3.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in data.tags ?? [])
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.goBack();
                            Navigation.instance
                                .navigate('/searchWithTag', args: i.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              i.name ?? "",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class TagsEnotesSection extends StatelessWidget {
  const TagsEnotesSection({Key? key, required this.data}) : super(key: key);
  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return (data.tags?.isEmpty ?? true)
        ? Container()
        : SizedBox(
            width: 70.w,
            height: 3.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in data.tags ?? [])
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.goBack();
                            Navigation.instance
                                .navigate('/searchWithTag', args: i.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              i.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 13.sp),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
