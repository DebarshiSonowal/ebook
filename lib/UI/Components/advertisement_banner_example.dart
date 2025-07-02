import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Model/advertisement.dart';
import '../../Networking/api_provider.dart';
import 'advertisement_banner.dart';

class AdvertisementBannerExample extends StatefulWidget {
  const AdvertisementBannerExample({Key? key}) : super(key: key);

  @override
  State<AdvertisementBannerExample> createState() =>
      _AdvertisementBannerExampleState();
}

class _AdvertisementBannerExampleState
    extends State<AdvertisementBannerExample> {
  List<AdvertisementBanner> banners = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAdvertisementBanners();
  }

  Future<void> fetchAdvertisementBanners() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiProvider.instance.fetchAdvertisementBanners();
      if (response.success ?? false) {
        setState(() {
          banners = response.result ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching advertisement banners: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advertisement Banners"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Library category banners
                  AdvertisementBannerSection(
                    banners: banners,
                    category: "library",
                    title: "Library Promotions",
                  ),

                  SizedBox(height: 2.h),

                  // Product category banners
                  AdvertisementBannerSection(
                    banners: banners,
                    category: "product",
                    title: "Featured Products",
                  ),

                  SizedBox(height: 2.h),

                  // External category banners
                  AdvertisementBannerSection(
                    banners: banners,
                    category: "external",
                    title: "External Promotions",
                  ),

                  SizedBox(height: 2.h),

                  // Custom single banner example
                  if (banners.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Featured Ad",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          AdvertisementBannerWidget(
                            banner: banners.first,
                            height: 25.h,
                            margin: EdgeInsets.zero,
                            onTap: () {
                              // Custom tap handler
                              debugPrint(
                                  "Custom banner tap: ${banners.first.id}");
                            },
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }
}

// Example integration in DataProvider (add this to your DataProvider class)
/*
class DataProvider extends ChangeNotifier {
  // ... existing code ...

  List<AdvertisementBanner> _advertisementBanners = [];
  bool _bannersLoading = false;

  List<AdvertisementBanner> get advertisementBanners => _advertisementBanners;
  bool get bannersLoading => _bannersLoading;

  Future<void> fetchAdvertisementBanners() async {
    _bannersLoading = true;
    notifyListeners();

    try {
      final response = await ApiProvider.instance.fetchAdvertisementBanners();
      if (response.success ?? false) {
        _advertisementBanners = response.result ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching advertisement banners: $e");
    } finally {
      _bannersLoading = false;
      notifyListeners();
    }
  }

  List<AdvertisementBanner> getBannersByCategory(String category) {
    return _advertisementBanners
        .where((banner) => banner.adCategory == category)
        .toList();
  }
}
*/
