import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/order_history.dart';
import '../../Networking/api_provider.dart';
import 'history_item_section.dart';

class HistoryCardItem extends StatelessWidget {
  const HistoryCardItem({
    Key? key,
    required this.current,
  }) : super(key: key);

  final OrderHistory current;

  @override
  Widget build(BuildContext context) {
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
              current.total.toString().trim()=="0.0"?"FREE":'₹${current.total}',
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
          HistoryItemsSection(current: current),
          SizedBox(
            height: 1.h,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () async {
              Navigation.instance.navigate('/loadingDialog');
              // await ApiProvider.instance
              //     .download2(current.id ?? 0);
              var status = await Permission.storage.status;
              if (status.isDenied) {
                if (await Permission.storage
                    .request()
                    .isGranted) {
                  await ApiProvider.instance
                      .download2(current.id ?? 0);
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    text: "We require storage permissions",
                  );
                }
                // We didn't ask for permission yet or the permission has been denied before but not permanently.
              } else {
                await ApiProvider.instance
                    .download2(current.id ?? 0);
              }
            },
            child: Text(
              'Download',
              style:
              Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.white,
                fontSize: 14.5.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}