// import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/book.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:search_page/search_page.dart';

import '../../Constants/constance_data.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            ConstanceData.primaryIcon,
            fit: BoxFit.fill,
            // color: Colors.white,
            height: 20,
            // width: 40,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Container(
          decoration: const BoxDecoration(
              color: ConstanceData.cardColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register as',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'WRITER',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 6,
        ),
        IconButton(
          onPressed: () {
            print('searh');
            Navigation.instance.navigate('/search');
            // showSearch(
            //   context: context,
            //   delegate: SearchPage<Book_old>(
            //     items: ConstanceData.Motivational,
            //     searchLabel: 'Search people',
            //     suggestion: Center(
            //       child: Text('Filter people by name, surname or age'),
            //     ),
            //     failure: Center(
            //       child: Text('No person found :('),
            //     ),
            //     filter: (current) => [
            //       current.name,
            //       current.author,
            //       // person.age.toString(),
            //     ],
            //     builder: (book) => ListTile(
            //       title: Text(book.name??''),
            //       subtitle: Text(book.author??''),
            //       trailing: CachedNetworkImage(
            //         imageUrl: book.image??'',
            //         height: 20,
            //         width: 20,
            //       ),
            //     ),
            //   ),
            // );
          },
          icon: const Icon(
            ConstanceData.searchIcon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: badge.Badge(
            position: badge.BadgePosition.bottomEnd(),
            // badgeColor: Colors.white,
            badgeContent: const Icon(
              ConstanceData.moreIcon,
              color: Colors.black,
              size: 10,
            ),
            child: const CircleAvatar(
              // radius: 25, // Image radius
              backgroundImage: AssetImage(
                ConstanceData.humanImage,
              ),
            ),
          ),
        )
      ],
    );
  }
}
