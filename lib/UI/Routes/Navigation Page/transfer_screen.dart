import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transfer Coins",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.sp,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 1.h,
        ),
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  void transfer(to_account, tranfer_points) async {
    final response =
        await ApiProvider.instance.transferRewards(to_account, tranfer_points);
    if (response.success ?? false) {
      //transferRewards
    } else {}
  }
}
