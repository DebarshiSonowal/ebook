import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Model/order_history.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Helper/navigator.dart';
import '../../../Storage/data_provider.dart';
import '../../Components/empty_widget.dart';
import '../../Components/history_item_section.dart';
import '../../Components/history_page_info.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.primaryColor,
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
      child: Consumer<DataProvider>(builder: (context, data, _) {
        return data.orders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/coming.json',
                    height: 22.h,
                    width: 44.w,
                    fit: BoxFit.fill,
                  ),
                ],
              )
            : HistoryPageInfo(
                data: data,
              );
      }),
    );
  }

  fetchOrderHistory() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchOrders();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHistory(response.orders);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchOrderHistory();
    });
  }
}
