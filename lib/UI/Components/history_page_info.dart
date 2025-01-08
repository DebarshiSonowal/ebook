// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Model/order_history.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
// import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Networking/api_provider.dart';
import 'history_card_item.dart';
import 'history_item_section.dart';

class HistoryPageInfo extends StatelessWidget {
  const HistoryPageInfo({
    Key? key,
    required this.data,
  }) : super(key: key);
  final DataProvider data;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (cont, count) {
          var current = data.orders[count];
          return HistoryCardItem(current: current);
        },
        separatorBuilder: (cont, count) {
          return SizedBox(
            height: 1.h,
          );
        },
        itemCount: data.orders.length);
  }
}
