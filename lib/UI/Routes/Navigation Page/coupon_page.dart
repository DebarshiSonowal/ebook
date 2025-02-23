import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:ebook/Model/discount.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/second_part_card.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade200,
        title: Text(
          "Apply Coupon",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.black,
                fontSize: 18.sp,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black45,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.coupons.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.coupons.length,
                  itemBuilder: (cont, count) {
                    var current = data.coupons[count];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, current.coupon);
                      },
                      child: CouponCard(
                        curvePosition: 130,
                        curveAxis: Axis.vertical,
                        backgroundColor: Color(0xffcaf3f0),
                        firstChild: Container(
                          color: Color(0xff358f8b),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 2.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${getValue(current.value?.toInt(), current.is_percent ?? 0)} OFF",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 0.1.h,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${current.title}",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondChild: secondPartCard(current: current),
                      ),
                    );
                  });
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchCupons();
    });
  }

  void fetchCupons() async {
    final reponse = await ApiProvider.instance.fetchDiscount();
    if (reponse.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCupons(reponse.cupons ?? []);
    }
  }

  getValue(int? int, int is_percent) {
    if (is_percent == 1) {
      return '₹${int}';
    } else {
      return '${int}%';
    }
  }
}
