import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';

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
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.cupons.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.cupons.length,
                  itemBuilder: (cont, count) {
                    var current = data.cupons[count];
                    return GestureDetector(
                      onTap: (){
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
                                        .headline1
                                        ?.copyWith(
                                          color: Colors.white,
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
                                        .headline4
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondChild: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Text(
                                      "Coupon Code",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      "${current.coupon}",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            color: Color(0xff358f8b),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "Valid Till -",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    Text(
                                      " ${current.valid_to}",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
