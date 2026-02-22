import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import '../../../Helper/navigator.dart';

class FlipBookView extends StatefulWidget {
  final String url;
  final String title;

  const FlipBookView({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<FlipBookView> createState() => _FlipBookViewState();
}

class _FlipBookViewState extends State<FlipBookView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Page resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.sp),
          onPressed: () => Navigation.instance.goBack(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
