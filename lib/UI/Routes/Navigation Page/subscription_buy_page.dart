import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubscriptionBuyPage extends StatefulWidget {
  const SubscriptionBuyPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<SubscriptionBuyPage> createState() => _SubscriptionBuyPageState();
}

class _SubscriptionBuyPageState extends State<SubscriptionBuyPage> {
  int? groupValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff172224),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigation.instance.goBack();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "SUBSCRIPTION PLANS",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    "${data.bannerList![data.currentTab].toList().firstWhere((element) => element.id == widget.id).title}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 6.w,
                    ),
                    color: const Color(0xff3e474a),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = data.bannerList![data.currentTab]
                                  .toList()
                                  .firstWhere(
                                      (element) => element.id == widget.id)
                                  .subscriptions[index];
                              return RadioListTile(
                                  activeColor: Colors.white,
                                  title: Row(
                                    children: [
                                      Text(
                                        "${item.title}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "₹${item.amount!.toInt()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  value: item.id ?? 0,
                                  groupValue: groupValue,
                                  onChanged: (val) {
                                    setState(() {
                                      groupValue = val as int?;
                                    });
                                  });
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 0.1.h,
                              );
                            },
                            itemCount: (data.bannerList![data.currentTab]
                                    .toList()
                                    .firstWhere(
                                        (element) => element.id == widget.id)
                                    .subscriptions
                                    .length ??
                                0),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Divider(
                              thickness: 0.2.h,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (groupValue != null) {
                              } else {
                                Fluttertoast.showToast(msg: "Select a plan");
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            child: Text(
                              "Buy Subscription",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 2.h,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
