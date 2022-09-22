import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/book.dart';
import 'package:sizer/sizer.dart';

class NewSearchBar extends StatelessWidget {
  const NewSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 7.h,
      width: double.infinity,
      color: Color(0xff121212),
      child: Row(
        children: [
          SizedBox(
            // width: 20.w,
            height: 7.h,
            child: Center(
              child: Image.asset(
                ConstanceData.primaryIcon,
                height: 6.h,
                width: 6.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                // color: ConstanceData.cardColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(color: Colors.white)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.h),
            child: Text(
              'REGISTER AS WRITER',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/search');
              // showSearch(
              //   context: context,
              //   delegate: SearchPage<Book_old>(
              //     items: ConstanceData.Motivational,
              //     searchLabel: 'Search Books',
              //     suggestion: const Center(
              //       child: Text('Filter people by name, surname or age'),
              //     ),
              //     failure: const Center(
              //       child: Text('No person found :('),
              //     ),
              //     filter: (current) => [
              //       current.name,
              //       current.author,
              //       // person.age.toString(),
              //     ],
              //     builder: (book) => ListTile(
              //       title: Text(
              //         book.name ?? '',
              //         style: Theme.of(context).textTheme.headline5,
              //       ),
              //       subtitle: Text(
              //         book.author ?? '',
              //         style: Theme.of(context).textTheme.headline6,
              //       ),
              //       trailing: CachedNetworkImage(
              //         imageUrl: book.image ?? '',
              //         height: 10.h,
              //         width: 15.w,
              //       ),
              //     ),
              //   ),
              // );
            },
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Consumer<DataProvider>(builder: (context, data, _) {
            return GestureDetector(
              onTap: () {
                Navigation.instance.navigate('/cartPage');
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: data.cartData?.items.isEmpty ?? true
                    ? const Icon(
                        ConstanceData.storeIcon,
                        // size: 2.h
                      )
                    : Badge(
                        position: BadgePosition.topEnd(),
                        badgeColor: ConstanceData.primaryColor,
                        badgeContent: Text(
                          '${data.cartData?.items.length ?? ""}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        child: const Icon(
                          ConstanceData.storeIcon,
                          // size: 2.h
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
