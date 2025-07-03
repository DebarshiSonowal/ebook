import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/navigator.dart';
import '../Model/advertisement.dart';
import '../Networking/api_provider.dart';

class AdsPopup extends StatefulWidget {
  const AdsPopup({
    super.key,
  });

  @override
  State<AdsPopup> createState() => _AdsPopupState();
}

class _AdsPopupState extends State<AdsPopup> with TickerProviderStateMixin {
  List<Advertisement> advertisements = [];
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    fetchAdvertisements();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchAdvertisements() async {
    try {
      final response = await ApiProvider.instance.fetchAdvertisement();
      if (response.success == true && response.result?.data != null) {
        setState(() {
          advertisements = response.result!.data!;
          isLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _animationController.forward();
    }
  }

  Future<void> _onAdTap(Advertisement ad) async {
    // Track ad click analytics
    if (ad.adId != null && ad.adId! > 0) {
      try {
        final response = await ApiProvider.instance.trackAdClick(ad.adId!);
        debugPrint('Ad click tracked successfully: ${response.message}');

        // Show success feedback to user (optional)
        if (mounted && response.status == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thank you for your interest!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green.shade600,
            ),
          );
        }
      } catch (e) {
        debugPrint('Failed to track ad click: $e');
        // Don't show error to user as this is analytics tracking
      }
    }

    // Handle ad interaction (redirect)
    if (ad.isInteractive == true && ad.redirectLink?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(ad.redirectLink!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch URL: ${ad.redirectLink}');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          )),
          child: Container(
            width: double.infinity,
            height: 100.h, // Full screen height
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildIOSCloseButton(),
                Expanded(
                  // Take remaining space
                  child: isLoading
                      ? _buildLoadingState()
                      : advertisements.isEmpty
                          ? _buildEmptyState()
                          : _buildAdContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIOSCloseButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 2.h),
      // Increased top padding for status bar
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 8.w), // Spacer for centering
          Text(
            'Advertisement',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          GestureDetector(
            onTap: () => Navigation.instance.goBack(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 40.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading advertisements...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 30.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ad_units_outlined,
            size: 48.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'No advertisements available',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdContent() {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          if (advertisements.length == 1)
            Expanded(
              child: _buildAdWidget(
                  advertisements[0], null), // Full available height
            ),
          if (advertisements.length == 2)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _buildAdWidget(advertisements[0], null),
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                    child: _buildAdWidget(advertisements[1], null),
                  ),
                ],
              ),
            ),
          if (advertisements.length >= 3)
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < 3 && i < advertisements.length; i++) ...[
                    Expanded(
                      child: _buildAdWidget(advertisements[i], null),
                    ),
                    if (i < 2 && i < advertisements.length - 1)
                      SizedBox(height: 1.h),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdWidget(Advertisement ad, double? height) {
    // Handle image, gif, and video ad types
    if ((ad.adType == 'image' || ad.adType == 'gif' || ad.adType == 'video') &&
        ad.content?.isNotEmpty == true) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () => _onAdTap(ad),
          child: Container(
            height: height,
            width: double.infinity,
            child: _buildMediaWidget(ad, height),
          ),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ad_units_outlined,
            color: Colors.grey.shade500,
            size: 32.sp,
          ),
          SizedBox(height: 1.h),
          Text(
            'Ad Content Not Available',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaWidget(Advertisement ad, double? height) {
    switch (ad.adType?.toLowerCase()) {
      case 'video':
        return _buildVideoWidget(ad, height);
      case 'gif':
      case 'image':
      default:
        return _buildImageWidget(ad, height);
    }
  }

  Widget _buildImageWidget(Advertisement ad, double? height) {
    return Image.network(
      ad.content!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.grey.shade100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Loading ${ad.adType ?? 'media'}...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMediaIcon(ad.adType),
                color: Colors.grey.shade500,
                size: 32.sp,
              ),
              SizedBox(height: 1.h),
              Text(
                '${ad.adType?.toUpperCase() ?? 'Media'} Not Available',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Tap to retry',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoWidget(Advertisement ad, double? height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // For now, show video as image with play overlay
          // You can integrate video_player package for actual video playback
          Image.network(
            ad.content!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    child,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(3.w),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                );
              }
              return Container(
                height: height,
                color: Colors.grey.shade100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Loading video...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade800,
                      Colors.grey.shade900,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_off,
                      color: Colors.grey.shade400,
                      size: 32.sp,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Video Not Available',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap to retry',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getMediaIcon(String? adType) {
    switch (adType?.toLowerCase()) {
      case 'video':
        return Icons.videocam_off;
      case 'gif':
        return Icons.gif;
      case 'image':
      default:
        return Icons.broken_image_outlined;
    }
  }
}
