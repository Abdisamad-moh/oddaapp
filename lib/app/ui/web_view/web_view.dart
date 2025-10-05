
import 'package:flutter/material.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  final String webUrl;
  final String title;
  
  const AppWebView({super.key, required this.webUrl, required this.title});

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      appBar: AppBar(
        backgroundColor: colorConstants.white,
        iconTheme: const IconThemeData(color: colorConstants.black),
        centerTitle: true,
        title: addText(
            widget.title, 
            getHeadingTextFontSIze(), 
            colorConstants.black, 
            FontWeight.w600
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebViewWidget(controller: _controller),
            _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}