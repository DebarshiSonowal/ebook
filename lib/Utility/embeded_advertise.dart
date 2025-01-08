import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import '../Constants/constance_data.dart';
// import '../../Helper/Constance.dart';

class EmbededAdvertise extends StatefulWidget {
  const EmbededAdvertise({super.key, required this.context});

  final ExtensionContext context;

  @override
  State<EmbededAdvertise> createState() => _EmbededAdvertiseState();
}

class _EmbededAdvertiseState extends State<EmbededAdvertise> {
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: ConstanceData.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 1.w),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Ad ',
                  style: Theme.of(widget.context.buildContext!)
                      .textTheme
                      .displaySmall
                      ?.copyWith(
                        fontSize: 7.sp,
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 1.h,
          // ),
          GestureDetector(
            onTap: () {
              _launchUrl(Uri.parse(widget.context.attributes['href']!));
            },
            child: Container(
              width: 100.w,
              padding: EdgeInsets.only(left: 4.w, right: 5.w, bottom: 0.9.h),
              child: CachedNetworkImage(
                // height: 6.h,
                // fit: BoxFit.contain,
                fit: BoxFit.fitWidth,
                imageUrl: imageUrl,
                placeholder: (cont, _) {
                  return Image.asset(
                    ConstanceData.emptyImage,
                    // color: Colors.black,
                  );
                },
                errorWidget: (cont, _, e) {
                  return Image.asset(
                    ConstanceData.emptyImage,
                    // color: Colors.black,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    extractImageUrl(widget.context.innerHtml).then((result) {
      debugPrint("url $result");
      setState(() {
        imageUrl = result!;
      });
    });
  }
}

Future<String?> extractImageUrl(String htmlString) async {
  // Parse the HTML string
  dom.Document document = parser.parse(htmlString);

  // Find the <img> tag using the 'src' attribute
  dom.Element? imgElement = document.querySelector('img[src]');

  // Extract the 'src' attribute value
  String? imageUrl = imgElement?.attributes['src'];

  return Future.value(imageUrl);
}

Future<void> _launchUrl(_url) async {
  if (await canLaunchUrl(_url)) {
    launchUrl(_url);
  } else {}
}
