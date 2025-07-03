import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/advertisement.dart';
import '../../Helper/navigator.dart';

class AdvertisementBannerWidget extends StatelessWidget {
  final AdvertisementBanner banner;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const AdvertisementBannerWidget({
    Key? key,
    required this.banner,
    this.onTap,
    this.margin,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      height: height ?? 20.h,
      width: width ?? double.infinity,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () async {
            // Handle custom onTap if provided
            if (onTap != null) {
              onTap!();
              return;
            }

            await _handleBannerTap();
          },
          child: _buildBannerContent(),
        ),
      ),
    );
  }

  Future<void> _handleBannerTap() async {
    debugPrint("Banner tapped: ${banner.adCategory} \n ${banner.redirectLink}");
    // Handle external redirect links first
    if (banner.redirectLink != null &&
        banner.redirectLink!.isNotEmpty &&
        banner.redirectLink != "") {
      try {
        final uri = Uri.parse(banner.redirectLink!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        } else {
          debugPrint("Cannot launch URL: ${banner.redirectLink}");
        }
      } catch (e) {
        debugPrint("Error launching URL: $e");
      }
      return;
    }

    // Handle category-based navigation with related_id
    if (banner.relatedId != null &&
        banner.relatedId! > 0 &&
        banner.adCategory != null) {
      try {
        switch (banner.adCategory!.toLowerCase()) {
          case 'library':
            // Navigate to library section or specific library item
            Navigation.instance
                .navigate('/libraryDetails', args: banner.relatedId);
            break;

          case 'e-book':
            Navigation.instance.navigate('/bookInfo', args: banner.relatedId);
            break;

          case 'ebook':
            // Navigate to specific book details
            Navigation.instance.navigate('/bookInfo', args: banner.relatedId);
            break;

          case 'e-note':
            Navigation.instance.navigate('/bookInfo', args: banner.relatedId);
            break;
          case 'enote':
            // Navigate to specific e-note details
            Navigation.instance.navigate('/bookInfo', args: banner.relatedId);
            break;

          case 'magazine':
            // Navigate to specific magazine details
            Navigation.instance.navigate('/bookInfo', args: banner.relatedId);
            break;

          case 'external':
            // For external type, try to use redirect_link or show message
            debugPrint("External ad clicked but no redirect link provided");
            if (banner.redirectLink != null &&
                banner.redirectLink!.isNotEmpty) {
              try {
                final uri = Uri.parse(banner.redirectLink!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  debugPrint(
                      "Cannot launch external URL: ${banner.redirectLink}");
                }
              } catch (e) {
                debugPrint("Error launching external URL: $e");
              }
            }
            break;

          default:
            debugPrint("Unknown ad category: ${banner.adCategory}");
        }
      } catch (e) {
        debugPrint("Error navigating for banner: $e");
      }
    } else {
      debugPrint("Banner has no valid related_id or category for navigation");
    }
  }

  Widget _buildBannerContent() {
    if (banner.adType == "image" && banner.content != null) {
      return CachedNetworkImage(
        imageUrl: banner.content!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.grey.shade400,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 30.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Ad Image',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Fallback for other ad types or missing content
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ad_units,
              size: 30.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 1.h),
            Text(
              'Advertisement',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (banner.adCategory != null && banner.adCategory!.isNotEmpty)
              Text(
                banner.adCategory!.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AdvertisementBannerSection extends StatelessWidget {
  final List<AdvertisementBanner> banners;
  final String category;
  final double? height;
  final bool showTitle;
  final String? title;
  final ScrollPhysics? physics;

  const AdvertisementBannerSection({
    Key? key,
    required this.banners,
    required this.category,
    this.height,
    this.showTitle = true,
    this.title,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredBanners =
        banners.where((banner) => banner.adCategory == category).toList();

    if (filteredBanners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              title ?? '${category.toUpperCase()} ADS',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        SizedBox(
          height: height ?? 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: physics ?? const BouncingScrollPhysics(),
            itemCount: filteredBanners.length,
            itemBuilder: (context, index) {
              return AdvertisementBannerWidget(
                banner: filteredBanners[index],
                width: 80.w,
                margin: EdgeInsets.only(
                  left: index == 0 ? 4.w : 2.w,
                  right: index == filteredBanners.length - 1 ? 4.w : 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
