import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Model/order_history.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
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
    return Scaffold(
      backgroundColor: ConstanceData.primaryColor,
      appBar: AppBar(
        backgroundColor: ConstanceData.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigation.instance.goBack();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          'Order History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              fetchOrderHistory();
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(top: 1.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/coming.json',
                        height: 28.h,
                        width: 56.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'No Orders Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Your order history will appear here once you make a purchase',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              : HistoryPageInfo(
                  data: data,
                );
        }),
      ),
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
