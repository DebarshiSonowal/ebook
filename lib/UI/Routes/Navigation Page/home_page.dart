import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Routes/Drawer/library.dart';
import 'package:ebook/UI/Routes/Drawer/more.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/CategoryBar.dart';
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
                const CategoryBar(),
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

  @override
  void initState() {
    super.initState();
    fetchCartItems();
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
                listen: false)
            .setIndex(0);
      }
      debugPrint('index ${_controller?.index}');
    });
  }

  void fetchCartItems() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchCart();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToCart(response.cart?.items ?? []);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCartData(response.cart!);
      // Navigation.instance.goBack();
    } else {
      // Navigation.instance.goBack();
    }
  }
}
