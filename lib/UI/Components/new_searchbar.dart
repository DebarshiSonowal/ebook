import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                showSearch(
                  context: context,
                  delegate: SearchPage<Book>(
                    items: ConstanceData.Motivational,
                    searchLabel: 'Search people',
                    suggestion: Center(
                      child: Text('Filter people by name, surname or age'),
                    ),
                    failure: Center(
                      child: Text('No person found :('),
                    ),
                    filter: (current) => [
                      current.name,
                      current.author,
                      // person.age.toString(),
                    ],
                    builder: (book) => ListTile(
                      title: Text(book.name??''),
                      subtitle: Text(book.author??''),
                      trailing: CachedNetworkImage(
                        imageUrl: book.image??'',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                // width: 50.w,
                height: 8.w,
                child: IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        labelText:  'Enter search terms',
                        labelStyle:  Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                        hintText: 'Enter search terms',
                        helperStyle: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                // color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 1.5.h,
          ),
          Container(
            decoration: const BoxDecoration(
                color: ConstanceData.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register as',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'WRITER',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigation.instance.navigate('/accountDetails');
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Badge(
                position: BadgePosition.bottomEnd(),
                badgeColor: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}