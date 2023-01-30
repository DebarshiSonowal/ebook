import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Model/home_banner.dart';

class BookImageInformationWidget extends StatelessWidget {
  const BookImageInformationWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(border: Border.all(color: Colors.white)),
      height: 25.h,
      width: 40.w,
      child: CachedNetworkImage(
        imageUrl: data ?? "",
        placeholder: (context, url) => const Padding(
          padding: EdgeInsets.all(18.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.person),
        fit: BoxFit.fill,
      ),
    );
  }
}