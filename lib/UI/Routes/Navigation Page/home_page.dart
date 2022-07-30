import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Routes/Drawer/library.dart';
import 'package:ebook/UI/Routes/Drawer/more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';


import '../../../Model/book.dart';
import '../../Components/bottom_navbar.dart';
import '../../Components/home_app_bar.dart';
import '../Drawer/home.dart';
import '../Drawer/store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer<DataProvider>(builder: (context, current, _) {
        return bodyWidget(current.currentIndex);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Image.asset(ConstanceData.primaryIcon),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const BottomNavBarCustom(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'WRITER',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 6,
        ),
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPage<Book>(
                items: ConstanceData.bestselling,
                searchLabel: 'Search e-books and books',
                suggestion: const Center(
                  child: Text(
                      'Filter e-books and books by name, author or genre'),
                ),
                failure: const Center(
                  child: Text('No material found :('),
                ),
                filter: (current) => [
                  current.name,
                  current.author,
                  // person.age.toString(),
                ],
                builder: (book) => ListTile(
                  title: Text(book.name ?? '',style: Theme.of(context).textTheme.headline5,),
                  subtitle: Text(book.author ?? '',style: Theme.of(context).textTheme.headline6,),
                  trailing: CachedNetworkImage(
                    imageUrl: book.image ?? '',
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
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
        )
      ],
    );
  }

  AppBar HomeAppBar(BuildContext context) {
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
          margin: const EdgeInsets.symmetric(vertical: 5),
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
        const Spacer(
          flex: 6,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            ConstanceData.searchIcon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        InkWell(
          splashColor: Colors.white,
          radius: 30,
          onTap: (){

          },
          child: Ink(
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
        )
      ],
    );
  }

  Widget bodyWidget(int currentIndex) {
    switch (currentIndex) {
      case 1:
        return const Librarypage();
      case 2:
        return const Store();
      case 3:
        return const More();
      default:
        return const Home();
    }
  }
}
