import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Routes/Drawer/library.dart';
import 'package:ebook/UI/Routes/Drawer/more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Components/bottom_navbar.dart';
import '../../Components/new_searchbar.dart';
import '../../Components/new_tab_bar.dart';
import '../Drawer/home.dart';
import '../Drawer/history.dart';

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
      child: WillPopScope(
        onWillPop: () async {
          // if (Provider.of<DataProvider>(
          //             Navigation.instance.navigatorKey.currentContext ??
          //                 context,
          //             listen: false)
          //         .currentIndex ==
          //     0) {
          Dialogs.materialDialog(
              msg: 'Are you sure ? you want to exit',
              title: "Exit",
              color: Colors.white,
              context: context,
              titleStyle: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                  ),
              msgStyle: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.black,
                  ),
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigation.instance.goBack();
                  },
                  text: 'Cancel',
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  text: 'Exit',
                  iconData: Icons.exit_to_app,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
          return false;
        },
        child: Scaffold(
          // appBar: buildAppBar(context),
          // backgroundColor: const Color(0xff121212),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            // color: Colors.white30,
            child: Column(
              children: [
                NewTabBar(controller: _controller),
                const NewSearchBar(),
                NewCategoryBar(context),
                Expanded(
                  child: Consumer<DataProvider>(builder: (context, current, _) {
                    return Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child:
                          bodyWidget(current.currentIndex, current.currentTab),
                    );
                  }),
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {},
          //   child: Image.asset(ConstanceData.primaryIcon),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomNavBarCustom(),
        ),
      ),
    );
  }

  Widget bodyWidget(int currentIndex, currentTab) {
    print(currentIndex);
    // if (currentTab == 0) {
    switch (currentIndex) {
      case 1:
        return const Librarypage();
      case 2:
        return const Librarypage();
      case 3:
        return const OrderHistoryPage();
      case 4:
        return const More();
      default:
        return const Home();
    }
    // } else {
    //   switch (currentIndex) {
    //     case 1:
    //       return const Librarypage();
    //     case 3:
    //       return const OrderHistoryPage();
    //     case 4:
    //       return const More();
    //     default:
    //       return const Home();
    //   }
    // }
  }

  Consumer<DataProvider> NewCategoryBar(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, current, _) {
      return current.currentIndex == 0
          ? Container(
              padding: EdgeInsets.only(top: .5.h),
              decoration: const BoxDecoration(
                color: const Color(0xff121212),
                border: Border(
                  bottom: BorderSide(
                    // color: selected == count
                    //     ? const Color(0xffffd400)
                    //     : Colors.black,
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              height: 4.5.h,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          current.categoryList[current.currentIndex].length ~/
                              2,
                      itemBuilder: (cont, count) {
                        var data =
                            current.categoryList[current.currentIndex][count];
                        return GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   selected = count;
                            //   debugPrint(count.toString());
                            //   current.setCategory(count);
                            // });
                            Navigation.instance.navigate('/selectCategories',
                                args: '${data.title},${data.id}');
                          },
                          child: Container(
                            // width: 18.w,
                            padding: EdgeInsets.all(0.2.h),
                            margin: const EdgeInsets.symmetric(horizontal: 5),

                            child: Center(
                              child: Text(
                                data.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      // fontSize: 1.5.h,
                                      // color: selected == count
                                      //     ? const Color(0xffffd400)
                                      //     : Colors.white,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 10.w,
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigation.instance.navigate('/categories');
                    },
                    child: Container(
                      width: 13.w,
                      height: 3.h,
                      padding: EdgeInsets.all(0.2.h),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                        child: Text(
                          'More ->',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 1.5.h,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: true)
              .formats
              ?.length ??
          2,
      vsync: this,
    );
    _controller?.addListener(() {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCurrentTab(_controller?.index ?? 0);
      if (Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .currentIndex ==
              1 ||
          Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .currentIndex ==
              2 ||
          Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .currentIndex ==
              3) {
        Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false).setIndex(0);
      }
      debugPrint('index ${_controller?.index}');
    });
  }
}
