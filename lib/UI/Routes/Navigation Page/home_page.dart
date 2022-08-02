import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:ebook/UI/Routes/Drawer/library.dart';
import 'package:ebook/UI/Routes/Drawer/more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:sizer/sizer.dart';
import '../../../Model/book.dart';
import '../../Components/bottom_navbar.dart';
import '../../Components/home_app_bar.dart';
import '../../Components/new_tab_bar.dart';
import '../Drawer/home.dart';
import '../Drawer/store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: buildAppBar(context),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                NewTabBar(controller: _controller),
                Expanded(
                  child: Consumer<DataProvider>(builder: (context, current, _) {
                    return bodyWidget(current.currentIndex,current.currentTab);
                  }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Image.asset(ConstanceData.primaryIcon),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: const BottomNavBarCustom(),
      ),
    );
  }



  Widget bodyWidget(int currentIndex,currentTab) {
    if (currentTab==0) {
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
    } else {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: EmptyWidget(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: ConstanceData.optionList.length,
      vsync: this,
    );
    _controller?.addListener(() {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCurrentTab(_controller?.index ?? 0);
    });
  }
}

