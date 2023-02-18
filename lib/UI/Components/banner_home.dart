
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
class BannerHome extends StatefulWidget {
  const BannerHome({Key? key}) : super(key: key);

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: ConstanceData.secondaryColor),
      child: CachedNetworkImage(
        imageUrl: ConstanceData.banner[0],
        width: double.infinity,
        fit: BoxFit.fill,
        height: 200,
      ),
    );
  }
}
