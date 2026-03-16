import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/library_plans_model.dart';
import '../../../Model/library_purchase_response.dart';
import '../../../Model/razorpay_key.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/data_provider.dart';
import '../../Components/ios_compliance_helper.dart';

class LibraryPlansScreen extends StatefulWidget {
  final int libraryId;
  final String libraryTitle;
  final List<LibraryPlan>? prefetchedPlans;

  const LibraryPlansScreen({
    Key? key,
    required this.libraryId,
    required this.libraryTitle,
    this.prefetchedPlans,
  }) : super(key: key);

  @override
  State<LibraryPlansScreen> createState() => _LibraryPlansScreenState();
}

class _LibraryPlansScreenState extends State<LibraryPlansScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<LibraryPlan> _plans = [];
  List<LibraryPlan> _originalPlans = [];
  int? _loadingPlanId;

  // Coupon
  final _couponController = TextEditingController();
  String? _appliedCoupon;
  bool _couponExpanded = false;
  bool _isApplyingCoupon = false;

  // Razorpay
  final _razorpay = Razorpay();
  double _pendingTotal = 0;
  String _pendingOrderId = '';

  @override
  void dispose() {
    _razorpay.clear();
    _couponController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    if (widget.prefetchedPlans != null) {
      _plans = widget.prefetchedPlans!;
      _originalPlans = widget.prefetchedPlans!;
      _isLoading = false;
    } else {
      _fetchPlans();
    }
  }

  Future<void> _fetchPlans() async {
    try {
      final response =
          await ApiProvider.instance.getLibraryPlans(widget.libraryId);
      if (!mounted) return;
      if (response.success) {
        setState(() {
          _plans = response.result.planList;
          _originalPlans = response.result.planList;
          _isLoading = false;
        });
        if (response.result.membershipApproveType == 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showPrivateLibrarySheet(
              response.result.restrictedMsg,
              response.result.planList,
            );
          });
        }
      } else {
        setState(() {
          _errorMessage = response.message.isNotEmpty
              ? response.message
              : 'Failed to load plans';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _formatPlanType(String planType) {
    switch (planType.toLowerCase()) {
      case 'monthly':
        return 'Monthly';
      case 'quarterly':
        return 'Quarterly';
      case 'halfyearly':
        return 'Half-Yearly';
      case 'yearly':
        return 'Yearly';
      default:
        return planType
            .split('_')
            .map((w) => w.isEmpty
                ? w
                : w[0].toUpperCase() + w.substring(1).toLowerCase())
            .join(' ');
    }
  }

  /// Icon for each plan type
  IconData _planIcon(String planType) {
    switch (planType.toLowerCase()) {
      case 'monthly':
        return Icons.calendar_today_rounded;
      case 'quarterly':
        return Icons.date_range_rounded;
      case 'halfyearly':
        return Icons.event_note_rounded;
      case 'yearly':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.card_membership_rounded;
    }
  }

  /// Gradient per plan type
  List<Color> _planGradient(String planType, bool isDefault) {
    if (isDefault) {
      return [const Color(0xFFB8860B), const Color(0xFFFFD700)];
    }
    switch (planType.toLowerCase()) {
      case 'monthly':
        return [const Color(0xFF1E2A3A), const Color(0xFF2E4260)];
      case 'quarterly':
        return [const Color(0xFF1A2535), const Color(0xFF2A3D55)];
      case 'halfyearly':
        return [const Color(0xFF1C2B3A), const Color(0xFF253A50)];
      case 'yearly':
        return [const Color(0xFF1E2D3D), const Color(0xFF2C4058)];
      default:
        return [const Color(0xFF252830), const Color(0xFF353A45)];
    }
  }

  /// Per-month equivalent label
  String _periodLabel(String planType) {
    switch (planType.toLowerCase()) {
      case 'monthly':
        return '/ month';
      case 'quarterly':
        return '/ 3 months';
      case 'halfyearly':
        return '/ 6 months';
      case 'yearly':
        return '/ year';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111217),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          if (IOSComplianceHelper.isIOS)
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.orange.shade900.withOpacity(0.15),
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.orange.shade900, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange.shade400, size: 16.sp),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Direct purchases are not available in-app on iOS. Tap any plan to learn more.',
                        style: TextStyle(
                          color: Colors.orange.shade200,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4FC3F7),
                  strokeWidth: 2.5,
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(child: _buildError())
          else if (_plans.isEmpty)
            SliverFillRemaining(child: _buildEmpty())
          else ...[
            SliverToBoxAdapter(
              child: _buildHeading(),
            ),
            SliverToBoxAdapter(
              child: _buildCouponSection(),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPlanCard(_plans[index]),
                  childCount: _plans.length,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildFooternote()),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  Razorpay helpers
  // ──────────────────────────────────────────

  Future<void> _startRazorpayFlow(LibraryPurchaseResult result) async {
    final keyResponse = await ApiProvider.instance.fetchRazorpay();
    if (!mounted) return;
    if (!(keyResponse.status ?? false) || keyResponse.razorpay == null) {
      _showSnackBar('Could not initiate payment. Please try again.',
          isError: true);
      return;
    }
    _pendingTotal = result.grandTotal;
    _pendingOrderId = result.orderId;
    _openRazorpay(keyResponse.razorpay!, result);
  }

  void _openRazorpay(RazorpayKey key, LibraryPurchaseResult result) {
    final profile =
        Provider.of<DataProvider>(context, listen: false).profile;
    final options = {
      'key': key.api_key,
      'amount': result.grandTotal * 100,
      'image':
          'https://tratri.in/assets/assets/images/logos/logo-razorpay.jpg',
      'name': '${profile?.f_name ?? ''} ${profile?.l_name ?? ''}',
      'description': 'Library Membership',
      'prefill': {
        'contact': profile?.mobile ?? '',
        'email': profile?.email ?? '',
      },
      'note': {
        'customer_id': result.subscriberId,
        'order_id': result.orderId,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      _showSnackBar('Could not open payment gateway.', isError: true);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final result = await ApiProvider.instance.verifyLibraryPayment(
      orderId: _pendingOrderId,
      razorpayPaymentId: response.paymentId ?? '',
      amount: _pendingTotal,
    );
    if (!mounted) return;
    if (result.status == true) {
      Navigator.of(context).pop();
      _showSnackBar(
        result.message?.isNotEmpty == true
            ? result.message!
            : 'Payment successful! Membership activated.',
      );
    } else {
      _showSnackBar(
        result.message?.isNotEmpty == true
            ? result.message!
            : 'Payment verification failed. Contact support.',
        isError: true,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showSnackBar(
        response.message?.isNotEmpty == true
            ? response.message!
            : 'Payment cancelled or failed.',
        isError: true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade800 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  Sliver App Bar
  // ──────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 15.h,
      pinned: true,
      backgroundColor: const Color(0xFF111217),
      leading: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 14.sp),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B3E), Color(0xFF111217)],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E3A8A).withOpacity(0.25),
                  ),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4FC3F7).withOpacity(0.08),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 7.h, 5.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.library_books_rounded,
                            color: const Color(0xFF4FC3F7), size: 14.sp),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            widget.libraryTitle.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF4FC3F7),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.8.h),
                    Text(
                      'Membership Plans',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
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
  }

  // ──────────────────────────────────────────
  //  Subheading
  // ──────────────────────────────────────────
  Widget _buildHeading() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            'Unlock full access to all books, magazines and e-notes.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  Plan Card
  // ──────────────────────────────────────────
  Widget _buildPlanCard(LibraryPlan plan) {
    final bool isPopular = plan.isDefault == 1;
    final bool hasDiscount = plan.discount > 0;
    final List<Color> gradient = _planGradient(plan.planType, isPopular);
    final accentColor = gradient.last;

    return Padding(
      padding: EdgeInsets.only(bottom: 1.2.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card body
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1E26),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPopular
                    ? const Color(0xFFFFD700).withOpacity(0.6)
                    : Colors.white.withOpacity(0.07),
                width: isPopular ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPopular
                      ? const Color(0xFFFFD700).withOpacity(0.06)
                      : Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header row ──────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 1.1.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient
                          .map((c) => c.withOpacity(0.15))
                          .toList(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      // Icon bubble
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          _planIcon(plan.planType),
                          color: Colors.white,
                          size: 15.sp,
                        ),
                      ),
                      SizedBox(width: 2.5.w),
                      // Name + type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              plan.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatPlanType(plan.planType),
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Discount chip
                      if (hasDiscount)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.3.h),
                          decoration: BoxDecoration(
                            color: Colors.green.shade900.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.green.shade700, width: 0.8),
                          ),
                          child: Text(
                            plan.isPercent == 1 
                              ? '${plan.discountValue.toStringAsFixed(0)}% OFF'
                              : '₹${plan.discount.toStringAsFixed(0)} OFF',
                            style: TextStyle(
                              color: Colors.green.shade400,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Price + CTA row ──────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 0.9.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pricing
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: plan.totalPrice.toStringAsFixed(0),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 1.5.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (hasDiscount)
                                  Text(
                                    '₹${plan.basePrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 18.sp,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey.shade600,
                                    ),
                                  ),
                                Text(
                                  _periodLabel(plan.planType),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // CTA Button
                      GestureDetector(
                        onTap: (IOSComplianceHelper.isIOS && plan.totalPrice > 0)
                            ? () => IOSComplianceHelper.showPurchaseInfoDialog(
                                context)
                            : (_loadingPlanId != null
                                ? null
                                : () async {
                                    setState(() => _loadingPlanId = plan.id);

                                    final response = await ApiProvider.instance
                                        .purchaseLibraryMembership(
                                      libraryId: widget.libraryId,
                                      planId: plan.id,
                                      couponCode: _appliedCoupon,
                                    );

                                if (!mounted) return;
                                setState(() => _loadingPlanId = null);

                                if (!response.success) {
                                  _showSnackBar(
                                    response.message.isNotEmpty
                                        ? response.message
                                        : 'Purchase failed. Try again.',
                                    isError: true,
                                  );
                                  return;
                                }

                                final approval =
                                    response.result.libraryApproval;

                                if (approval == 0) {
                                  await _startRazorpayFlow(response.result);
                                } else if (approval == 1) {
                                  if (mounted) Navigator.of(context).pop();
                                  _showSnackBar(
                                    response.message.isNotEmpty
                                        ? response.message
                                        : 'Membership activated!',
                                  );
                                } else {
                                  _showSnackBar(
                                    response.message.isNotEmpty
                                        ? response.message
                                        : 'Request submitted! The admin will review it.',
                                  );
                                }
                              }),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: gradient.first.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _loadingPlanId == plan.id
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Feature chips row ───────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 0.7.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _featureChip(
                          Icons.book_rounded, 'Books', accentColor),
                      _featureChip(
                          Icons.offline_bolt_rounded, 'Offline', accentColor),
                      _featureChip(
                          Icons.headset_rounded, 'Support', accentColor),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // "Most Popular" badge
          if (isPopular)
            Positioned(
              top: -1,
              right: 3.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 2.w, vertical: 0.3.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded,
                        color: Colors.white, size: 10.sp),
                    SizedBox(width: 1.w),
                    Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // iOS Info Badge
          if (IOSComplianceHelper.isIOS)
            Positioned(
              top: -8,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 10.sp),
                    SizedBox(width: 1.w),
                    Text(
                      'iOS INFO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _featureChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14.sp),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  //  Coupon Section
  // ──────────────────────────────────────────
  Widget _buildCouponSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 1.2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Toggle / status row ─────────────────────────
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _appliedCoupon != null
                ? null
                : () => setState(() => _couponExpanded = !_couponExpanded),
            child: Row(
              children: [
                Icon(
                  _appliedCoupon != null
                      ? Icons.check_circle_outline_rounded
                      : Icons.local_offer_outlined,
                  color: _appliedCoupon != null
                      ? Colors.green.shade400
                      : const Color(0xFF4FC3F7),
                  size: 14.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  _appliedCoupon != null
                      ? 'Coupon applied: $_appliedCoupon'
                      : 'Have a coupon code?',
                  style: TextStyle(
                    color: _appliedCoupon != null
                        ? Colors.green.shade400
                        : const Color(0xFF4FC3F7),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_appliedCoupon != null)
                  GestureDetector(
                    onTap: () => setState(() {
                      _plans = _originalPlans;
                      _appliedCoupon = null;
                      _couponController.clear();
                      _couponExpanded = false;
                    }),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.grey.shade500,
                          size: 15.sp,
                        ),
                      ],
                    ),
                  )
                else
                  Icon(
                    _couponExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade500,
                    size: 18.sp,
                  ),
              ],
            ),
          ),

          // ── Expandable input ────────────────────────────
          if (_couponExpanded && _appliedCoupon == null) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1E26),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        letterSpacing: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16.sp,
                          letterSpacing: 0,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0.6.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Apply button
                  GestureDetector(
                    onTap: _isApplyingCoupon
                        ? null
                        : () async {
                            final code = _couponController.text.trim();
                            if (code.isEmpty) return;
                            setState(() => _isApplyingCoupon = true);

                            final response = await ApiProvider.instance
                                .applyCoupon(
                              libraryId: widget.libraryId,
                              couponCode: code,
                            );

                            if (!mounted) return;
                            setState(() => _isApplyingCoupon = false);

                            if (!response.success) {
                              _showSnackBar(
                                response.message.isNotEmpty
                                    ? response.message
                                    : 'Invalid coupon code.',
                                isError: true,
                              );
                              return;
                            }

                            setState(() {
                              _plans = response.result.planList;
                              _appliedCoupon = code;
                              _couponExpanded = false;
                            });
                            _showSnackBar(
                              response.message.isNotEmpty
                                  ? response.message
                                  : 'Coupon "$code" applied!',
                            );
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w, vertical: 0.8.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isApplyingCoupon
                              ? [Colors.grey.shade800, Colors.grey.shade700]
                              : const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _isApplyingCoupon
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  Footer note
  // ──────────────────────────────────────────
  Widget _buildFooternote() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded,
              color: Colors.grey.shade600, size: 13.sp),
          SizedBox(width: 1.5.w),
          Text(
            'Secure payment · Cancel anytime',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  Private Library Sheet
  // ──────────────────────────────────────────
  void _showPrivateLibrarySheet(String? restrictedMsg, List<LibraryPlan> plans) {
    if (!mounted) return;
    final TextEditingController couponController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1E26),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 3.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 10.w,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    // Lock icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.lock_rounded,
                          color: Colors.white, size: 22.sp),
                    ),
                    SizedBox(height: 2.h),

                    // Title
                    Text(
                      'Private Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Description
                    Text(
                      restrictedMsg?.isNotEmpty == true
                          ? restrictedMsg!
                          : 'This is a private library. Send a membership request to get access.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15.sp,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                  // Membership Request Info (iOS Only)
                  if (IOSComplianceHelper.isIOS) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade800.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade300, size: 18.sp),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Notice: This is a membership request, not a direct purchase. You are requesting access directly from the library owner.',
                              style: TextStyle(
                                color: Colors.blue.shade100,
                                fontSize: 13.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Coupon Disclaimer (iOS Only)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade900.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade800.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange.shade300, size: 18.sp),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              "Disclaimer: Coupon codes are managed by the library owner. Our app doesn't facilitate coupon distribution or maintenance.",
                              style: TextStyle(
                                color: Colors.orange.shade100,
                                fontSize: 13.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ] else if (plans.isNotEmpty) ...[
                    // Informational Plans List (Android Only)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Available Plans (For Information)',
                        style: TextStyle(
                          color: const Color(0xFF4FC3F7).withOpacity(0.8),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: plans.length,
                        separatorBuilder: (_, __) => SizedBox(height: 1.h),
                        itemBuilder: (context, index) {
                          final p = plans[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.2.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.card_membership,
                                    color: Colors.grey.shade500, size: 14.sp),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    p.title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.sp),
                                  ),
                                ),
                                Text(
                                  '₹${p.totalPrice.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                  ],

                    // Coupon field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Coupon Code (Optional)',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextField(
                      controller: couponController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        letterSpacing: 1.2,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                        ),
                        prefixIcon: Icon(Icons.local_offer_rounded,
                            color: Colors.purple.shade300, size: 16.sp),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.purple.shade400, width: 1.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Submit button
                    GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () async {
                              setSheetState(() => isSubmitting = true);

                              final response = await ApiProvider.instance
                                  .purchaseLibraryMembership(
                                libraryId: widget.libraryId,
                                couponCode: couponController.text,
                              );

                              if (!mounted) return;
                              Navigator.of(context).pop(); // close sheet

                              if (!response.success) {
                                _showSnackBar(
                                  response.message.isNotEmpty
                                      ? response.message
                                      : 'Failed to send request. Please try again.',
                                  isError: true,
                                );
                                return;
                              }

                              _showSnackBar(
                                response.message.isNotEmpty
                                    ? response.message
                                    : 'Request submitted! The library admin will review it.',
                              );

                              if (response.result.isRefresh == 1) {
                                _fetchPlans();
                              }
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1.6.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSubmitting
                                ? [Colors.grey.shade700, Colors.grey.shade600]
                                : [
                                    const Color(0xFF6A1B9A),
                                    const Color(0xFFAB47BC)
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6A1B9A).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Send Membership Request',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  Error / Empty states
  // ──────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded,
                  color: Colors.red.shade400, size: 36.sp),
            ),
            SizedBox(height: 2.5.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchPlans();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_outlined,
              color: Colors.grey.shade700, size: 48.sp),
          SizedBox(height: 2.h),
          Text(
            'No membership plans available',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
