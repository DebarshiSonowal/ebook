import 'package:html/dom.dart';
import 'package:html/dom.dart' as dom;

import 'package:html/parser.dart' as parser;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class CustomImageExtension extends HtmlExtension{



  @override
  Set<String> get supportedTags => {"img"};
  @override
  InlineSpan build(ExtensionContext context) {
    debugPrint(context.innerHtml);
    return WidgetSpan(
      child: Container(
        color: Colors.black,
        // width: 90.h,
        child: CachedNetworkImage(
            imageUrl:context.attributes['src']??"",
          // fit: BoxFit.cover,
          height: double.tryParse(context.attributes['height']??"100"),
          width: double.tryParse(context.attributes['width']??"100"),
        ),
        // child: material.Text(context.attributes.toString()),
      ),
    );
  }

  const CustomImageExtension();

  String getImage(String html){
    Document document = parser.parse(html);

    // Find the <img> element
    dom.Element? imgElement = document.querySelector('img');

    if (imgElement != null) {
      // Get the value of the 'src' attribute
      String imageUrl = imgElement.attributes['src']??"";
      return imageUrl; // Output: https://tratri.in/public/storage/photos/81/WhatsApp Image 2023-05-23 at 4.26.27 PM.jpeg
    } else {
      return "";
    }
  }

}