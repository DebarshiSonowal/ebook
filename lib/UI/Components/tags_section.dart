import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/home_banner.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({Key? key, required this.data}) : super(key: key);
  final Book data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 4.h,
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
                      Navigation.instance.navigate(
                          '/searchWithTag',
                          args: i.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white),
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(5)),
                      ),
                      child: Text(
                        i.name ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline5,
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
