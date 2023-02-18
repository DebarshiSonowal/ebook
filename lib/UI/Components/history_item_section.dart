import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Model/order_history.dart';

class HistoryItemsSection extends StatelessWidget {
  const HistoryItemsSection({
    Key? key,
    required this.current,
  }) : super(key: key);

  final OrderHistory current;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (cont, count) {
          var data = current.orderItems[count];
          return Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 4.w, vertical: 1.h),
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
                        width: 2.w,
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
        itemCount: current.orderItems.length);
  }
}