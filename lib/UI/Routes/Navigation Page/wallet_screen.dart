import 'package:awesome_icons/awesome_icons.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../Helper/navigator.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigation.instance.goBack();
          },
        ),
        title: Text(
          "Wallet",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.black,
                fontSize: 19.sp,
              ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Skeletonizer(
          enabled: loading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Reward Points",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.coins,
                                color: Colors.amber,
                                size: 25.sp,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Consumer<DataProvider>(
                                  builder: (context, data, _) {
                                return Text(
                                  "${data.rewardResult?.totalPoints ?? 0}",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 23.sp,
                                      ),
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigation.instance.navigate("/transfer");
                          showTransferDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Text(
                            "Transfer",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff121212),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rules",
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  decoration: TextDecoration.underline,
                                ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Consumer<DataProvider>(builder: (context, data, _) {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = data.rewardResult?.rules![index];
                            return SizedBox(
                              width: 80.w,
                              child: Text(
                                "$item",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 0.5.h,
                            );
                          },
                          itemCount: data.rewardResult?.rules?.length ?? 0,
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Transactions",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                        decoration: TextDecoration.underline,
                      ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Consumer<DataProvider>(builder: (context, data, _) {
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = data.rewardResult?.rewardList![index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff121212),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  child: Text(
                                    item?.title ?? "Transaction",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  item?.chapterUpdatedAt ??
                                      DateTime.now().toString(),
                                  // "${DateTime.parse(item?.chapterUpdatedAt ?? "${DateTime.now()}")}",
                                  // "${DateFormat("dd/MM/yyyy HH:mm AM").format()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  (item?.is_reward_in == "in" ?? false)
                                      ? FontAwesomeIcons.plus
                                      : FontAwesomeIcons.minus,
                                  color: (item?.is_reward_in == "in" ?? false)
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16.sp,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Icon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.amber,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  "${item?.rewardPoint ?? 0}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 1.h);
                    },
                    itemCount: data.rewardResult?.rewardList?.length ?? 0,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchData() async {
    setState(() {
      loading = true;
    });
    final response = await ApiProvider.instance.getRewards();
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setRewards(response.result!);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void showTransferDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String mobileNumber = '';
        String amount = '';

        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Transfer Points',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  mobileNumber = value;
                },
              ),
              SizedBox(height: 2.h),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Points to Transfer',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  amount = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigation.instance.goBack();
              },
            ),
            TextButton(
              child: Text(
                'Transfer',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (mobileNumber.isNotEmpty && amount.isNotEmpty) {
                  startTransfer(mobileNumber, amount);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void startTransfer(to_account, tranfer_points) async {
    final response =
        await ApiProvider.instance.transferRewards(to_account, tranfer_points);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message ?? "Success",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      fetchData();
    } else {
      Navigation.instance.goBack();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message ?? "Something went wrong",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
