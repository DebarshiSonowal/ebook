import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Model/cart_item.dart';
import '../../Storage/data_provider.dart';

class CartPageItem extends StatelessWidget {
  const CartPageItem(
      {Key? key,
      required this.data,
      required this.current,
      required this.simpleIntInput,
      required this.removeItem})
      : super(key: key);
  final DataProvider data;
  final CartItem current;
  final int simpleIntInput;
  final Function(int id) removeItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 15.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data.items.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          height: 13.h,
                          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                          width: 20.w,
                          child: CachedNetworkImage(
                            imageUrl: current.item_image ?? "",
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 5.w,
                  ),
                  // SizedBox(
                  //   width: 5.w,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          '${current.name}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Text(
                        '${current.item_code == null || current.item_code == "" ? 'NA' : current.item_code}',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      Text(
                        ((current.item_unit_cost ?? 1) * simpleIntInput) == 0
                            ? "Free"
                            : '₹${(current.item_unit_cost ?? 1) * simpleIntInput}',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: ((current.item_unit_cost ?? 1) *
                                              simpleIntInput) ==
                                          0
                                      ? Colors.green
                                      : Colors.white,
                                  // fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0.5.w,
            ),
            const DottedLine(
              dashColor: Colors.white60,
            ),
            GestureDetector(
              onTap: () {
                removeItem(current.item_id!);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Remove',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
