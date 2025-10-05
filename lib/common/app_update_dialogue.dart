

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateAppDialog {
  static void show(BuildContext context,String url) {
    showDialog(
      context: context,barrierDismissible: false,
      builder: (_) => UpdateAppDialogWidget(url: url),
    );
  }
}

class UpdateAppDialogWidget extends StatefulWidget {
  String? url;

  UpdateAppDialogWidget({super.key, this.url});
  @override
  State<UpdateAppDialogWidget> createState() => _UpdateAppDialogWidgetState();
}

class _UpdateAppDialogWidgetState extends State<UpdateAppDialogWidget> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent dialog dismissal when pressing the back button
        return false;
      },
      child: AlertDialog(
        title: const Text("New version available"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Please update to the latest version of the app."),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Skip for now'),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () {
              _launchAppOrPlayStore1(widget.url.toString());
            },
          ),
        ],
      ),
    );
  }

  /*void _launchAppOrPlayStore() {
    final appId = Platform.isAndroid ? 'com.app.odda' : '6444509766';
    final url = Uri.parse(
      Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }*/
  void _launchAppOrPlayStore1(String storeUrl) {
    // final appId = Platform.isAndroid ? 'com.app.odda' : '6444509766';

    print('google play or app store url:::$storeUrl:::');
    final url = Uri.parse(storeUrl);
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}