import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Storage/data_provider.dart';
import 'package:sizer/sizer.dart';

class BottomNavBarCustom extends StatefulWidget {
  const BottomNavBarCustom({Key? key}) : super(key: key);

  @override
  State<BottomNavBarCustom> createState() => _BottomNavBarCustomState();
}

class _BottomNavBarCustomState extends State<BottomNavBarCustom> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return BottomNavigationBar(
          backgroundColor: ConstanceData.secondaryColor,
          selectedItemColor: Colors.blue,
          currentIndex: data.currentIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          //
          // unselectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(
            fontSize: 1.5.h,
            color: Colors.white,
          ),
          onTap: (i) {
            if (i != 4) {
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .setIndex(i);
            } else if (i == 2) {
            } else {
              Navigation.instance.navigate('/accountDetails');
            }
          },
          items: [
            const BottomNavigationBarItem(
                backgroundColor: ConstanceData.secondaryColor,
                icon: Icon(ConstanceData.homeIcon),
                label: 'Home'),
            const BottomNavigationBarItem(
                backgroundColor: ConstanceData.secondaryColor,
                icon: Icon(ConstanceData.libraryIcon),
                label: 'Library'),
            BottomNavigationBarItem(
                backgroundColor: ConstanceData.secondaryColor,
                icon: Image.asset(
                  ConstanceData.primaryIcon,
                  height: 5.h,
                  width: 5.h,
                  fit: BoxFit.fill,
                ),
                label: ''),
            const BottomNavigationBarItem(
                backgroundColor: ConstanceData.secondaryColor,
                icon: Icon(ConstanceData.orderIcon),
                label: 'Orders'),
            const BottomNavigationBarItem(
                backgroundColor: ConstanceData.secondaryColor,
                icon: CircleAvatar(
                  radius: 15, // Image radius
                  backgroundImage: AssetImage(
                    ConstanceData.humanImage,
                  ),
                ),
                label: 'More'),
          ]);
    });
  }
}
