import 'package:html/dom.dart';
import 'package:html/dom.dart' as dom;

import 'package:html/parser.dart' as parser;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class CustomSpaceExtension extends HtmlExtension {

  @override
  Set<String> get supportedTags => {"hr"};

  const CustomSpaceExtension();

  @override
  InlineSpan build(ExtensionContext context) {
    debugPrint(context.innerHtml);
    return WidgetSpan(
      child: Container(),
    );
  }
}
