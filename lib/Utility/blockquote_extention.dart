import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

// import '../../Helper/Constance.dart';
// import '../../Navigation/Navigate.dart';

class BlockquoteExtension extends HtmlExtension {
  final NavigationDelegate? navigationDelegate;

  const BlockquoteExtension({
    this.navigationDelegate,
  });

  @override
  Set<String> get supportedTags => {"blockquote"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: Container(
        color: Colors.black,
        height: 48.h,
        // width: 90.h,
        child: GestureDetector(
          onTap: () {
            _launchUrl(Uri.parse(""));
          },
          child: WebViewWidget(
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()
              )
            },
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..enableZoom(true)
              ..loadHtmlString(
                getHtmlString("1668455627319033857"),
              ),
          ),
        ),
      ),
    );
  }

  isAd(String innerHtml) {
    return innerHtml.contains("ad_managers");
  }

  String extractTwitterId(String htmlString) {
    RegExp regExp = RegExp(r'@(\w+)');
    Iterable<RegExpMatch> matches = regExp.allMatches(htmlString);
    String twitterId = '';
    for (RegExpMatch match in matches) {
      twitterId = match.group(1)!;
      break; // Use the first match found
    }
    return twitterId;
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      launchUrl(_url);
    } else {}
  }

  String getHtmlString(String? tweetId) {
    print("#!)!)!: ${tweetId}");
    return """
      <html>
      
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <body>
            <div id="container"></div>
                
        </body>
        <script id="twitter-wjs" type="text/javascript" async defer src="https://platform.twitter.com/widgets.js" onload="createMyTweet()"></script>
        <script>
        
       
      function  createMyTweet() {  
         var twtter = window.twttr;
  
         twttr.widgets.createTweet(
          '$tweetId',
          document.getElementById('container'),
          {
          width:250
          }
        )
      }
        </script>
        
      </html>
    """;
  }

//   "blockquote": (context, child) {
//     return context.tree.element?.innerHtml
//         .split("=")
//         .length ==
//         3
//         ? SizedBox(
//       height: 28.h,
//       // width: 90.h,
//       child: GestureDetector(
//         onTap: () {
//           _launchUrl(Uri.parse(context
//               .tree.element?.innerHtml
//               .split("=")[3]
//               .split("?")[0]
//               .substring(1) ??
//               ""));
//
//           // print(context.tree.element?.innerHtml
//           //     .split("=")[3]
//           //     .split("?")[0]);
//         },
//         child: AbsorbPointer(
//           child: WebView(
//             gestureNavigationEnabled: false,
//             zoomEnabled: true,
//             initialUrl: Uri.dataFromString(
//               getHtmlString(context
//                   .tree.element?.innerHtml
//                   .split("=")[3]
//                   .split("?")[0]
//                   .split("/")
//                   .last),
//               mimeType: 'text/html',
//               encoding: Encoding.getByName(
//                   'utf-8'),
//             ).toString(),
//             javascriptMode:
//             JavascriptMode.unrestricted,
//           ),
//         ),
//       ),
//     )
//         : Container();
//     // return Container(
//     //     child: Text(
//     //   '${context.tree.element?.innerHtml.split("=")[3].split("?")[0].split("/").last}',
//     //   style: TextStyle(color: Colors.black),
//     // ));
//   },
// },
}
