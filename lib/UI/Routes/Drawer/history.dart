import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Helper/navigator.dart';
import '../../../Storage/data_provider.dart';
import '../../Components/empty_widget.dart';

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
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (cont, count) {
                  var current = data.orders[count];
                  return Card(
                    color: Colors.grey.shade100,
                    child: ExpansionTile(
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${current.voucher_no}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(
                                        // fontSize: 2.5.h,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${current.order_date}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      // fontSize: 2.5.h,
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${current.total}',
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline3?.copyWith(
                                      // fontSize: 2.5.h,
                                      color: Colors.green,
                                    ),
                          ),
                        ],
                      ),
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (cont, count) {
                              var data = current.orderItems[count];
                              return Card(
                                color: Colors.grey.shade100,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                            data.book?.profile_pic ?? "",
                                            height: 5.h,
                                          ),
                                          SizedBox(
                                            width:2.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data.book?.title}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2
                                                    ?.copyWith(
                                                  // fontSize: 2.5.h,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              Text(
                                                '${data.book?.writer}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                  // fontSize: 2.5.h,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                      Text(
                                        '₹${data.selling_unit_price}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                          // fontSize: 2.5.h,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (cont, count) {
                              return SizedBox(
                                height: 1.h,
                              );
                            },
                            itemCount: current.orderItems.length),
                      ],
                    ),
                  );
                },
                separatorBuilder: (cont, count) {
                  return SizedBox(
                    height: 1.h,
                  );
                },
                itemCount: data.orders.length);
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
