import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/order_history.dart';
import '../../Networking/api_provider.dart';
import 'history_item_section.dart';

class HistoryCardItem extends StatefulWidget {
  const HistoryCardItem({
    Key? key,
    required this.current,
  }) : super(key: key);

  final OrderHistory current;

  @override
  State<HistoryCardItem> createState() => _HistoryCardItemState();
}

class _HistoryCardItemState extends State<HistoryCardItem>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getStatusColor() {
    switch (widget.current.status) {
      case 1:
        return const Color(0xff4CAF50); // Green
      case 2:
        return const Color(0xff2196F3); // Blue
      case 3:
        return const Color(0xffF44336); // Red
      default:
        return const Color(0xffFF9800); // Orange
    }
  }

  IconData _getStatusIcon() {
    switch (widget.current.status) {
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.local_shipping_outlined;
      case 3:
        return Icons.cancel_outlined;
      default:
        return Icons.schedule_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFree = widget.current.total == 0.0;
    final Color statusColor = _getStatusColor();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: ConstanceData.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header Section
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleExpansion,
                splashColor: ConstanceData.primaryColor.withOpacity(0.1),
                highlightColor: ConstanceData.primaryColor.withOpacity(0.05),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      // Top Row - Order Info and Price
                      Row(
                        children: [
                          // Status Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getStatusIcon(),
                              color: statusColor,
                              size: 22,
                            ),
                          ),

                          SizedBox(width: 3.w),

                          // Order Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.current.voucherNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  widget.current.formattedOrderDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Price and Arrow
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isFree
                                      ? const Color(0xff4CAF50)
                                          .withOpacity(0.15)
                                      : ConstanceData.cardColor
                                          .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isFree
                                        ? const Color(0xff4CAF50)
                                        : ConstanceData.cardColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  isFree
                                      ? 'FREE'
                                      : '₹${widget.current.grandTotal.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isFree
                                            ? const Color(0xff4CAF50)
                                            : ConstanceData.cardColor,
                                      ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              AnimatedBuilder(
                                animation: _rotationAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationAnimation.value * 3.14159,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey.shade400,
                                      size: 22,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 2.5.h),

                      // Status and Payment Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.6.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.current.orderStatus,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                            ),
                          ),

                          // Payment Status
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.6.h,
                            ),
                            decoration: BoxDecoration(
                              color: widget.current.isPaid == 1
                                  ? const Color(0xff4CAF50).withOpacity(0.1)
                                  : const Color(0xffFF9800).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: widget.current.isPaid == 1
                                    ? const Color(0xff4CAF50).withOpacity(0.3)
                                    : const Color(0xffFF9800).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.current.isPaid == 1
                                      ? Icons.verified
                                      : Icons.schedule,
                                  size: 14,
                                  color: widget.current.isPaid == 1
                                      ? const Color(0xff4CAF50)
                                      : const Color(0xffFF9800),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  widget.current.paymentStatus,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: widget.current.isPaid == 1
                                            ? const Color(0xff4CAF50)
                                            : const Color(0xffFF9800),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expanded Content with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isExpanded ? null : 0,
              child: isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade700,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Order Details Section
                          Container(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Header
                                Row(
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      color: ConstanceData.cardColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                'Order Details',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                    ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 2.h),

                                // History Items
                                Container(
                                  decoration: BoxDecoration(
                                    color: ConstanceData.secondaryColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade800,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: HistoryItemsSection(
                                      current: widget.current),
                                ),

                                SizedBox(height: 3.h),

                                // Download Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 5.5.h,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      Navigation.instance
                                          .navigate('/loadingDialog');
                                      // Add your download logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ConstanceData.primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: ConstanceData.cardColor,
                                          width: 1,
                                        ),
                                ),
                              ),
                                    icon: Icon(
                                      Icons.download_rounded,
                                      size: 18,

                                      color: ConstanceData.cardColor,
                                    ),
                                    label: Text(
                                      'Download Invoice',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
