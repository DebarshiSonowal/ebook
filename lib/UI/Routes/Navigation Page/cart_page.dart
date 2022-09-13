import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ebook/Model/cart_item.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String cupon='';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade200,
        title: Text(
          "Cart",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return data.cartData == null
              ? Container()
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ordering for someone else?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        final response = await Navigation.instance.navigate('/couponPage');
                                        if(response != null){
                                          setState(() {
                                            cupon = response;
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Apply Coupon',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(color: Colors.green,
                                        fontWeight: FontWeight.bold,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.items.length,
                                itemBuilder: (cont, count) {
                                  var simpleIntInput = 1;
                                  var current = data.items[count];
                                  return Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 2.w),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 15.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                data.items.isNotEmpty
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white)),
                                                        height: 13.h,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    1.5.w),
                                                        width: 20.w,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: current
                                                                  .item_image ??
                                                              "",
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    18.0),
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.image,
                                                                  color: Colors
                                                                      .white),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${current.name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '${current.item_code == null || current.item_code == "" ? 'NA' : current.item_code}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '₹${(current.item_unit_cost ?? 1) * simpleIntInput}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const DottedLine(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Ordering for someone else?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(1.h),
                        height: 20.h,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deliver to other | 3-5 Days',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                    ),
                                    Text(
                                      'Bishnu Nagar, Joysagar, Sivasagar, Dicial Dhulia Gaon',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const DottedLine(),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${getTotalAmount(data.cartData!)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                        Text(
                                          'View Detailed Bill',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side:
                                                BorderSide(color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Proceede to Pay'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  getTotalAmount(Cart data) {
    // double price = 0;

    return data.total_price;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchCartItems();
    });
  }

  void fetchCartItems() async {
    Navigation.instance.navigate('/loadingDialog');
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
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }
}