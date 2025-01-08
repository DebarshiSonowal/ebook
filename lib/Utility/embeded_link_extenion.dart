import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:gplusapp/UI/view/embeded_advertise.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

// import '../Helper/Constance.dart';
import '../Helper/navigator.dart';
// import '../Navigation/Navigate.dart';
import 'embeded_advertise.dart';

class EmbeddedLinkExtension extends HtmlExtension {
  final NavigationDelegate? navigationDelegate;
  final int type;

  const EmbeddedLinkExtension(
    this.type, {
    this.navigationDelegate,
  });

  @override
  Set<String> get supportedTags => {"a"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: isAd(context.innerHtml)
          ? EmbededAdvertise(context: context)
          : GestureDetector(
              onTap: () {
                _launchUrl(Uri.parse(
                    context.attributes['href'] ?? "https://tratri.in/"));
              },
              child: Text(
                context.innerHtml.replaceAll(";", "").replaceAll("&nbsp", ""),
                style:
                    Theme.of(Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          color: ConstanceData.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
              ),
            ),
    );
  }

  isAd(String innerHtml) {
    return innerHtml.contains("ad_managers");
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      launchUrl(_url);
    } else {}
  }
}
