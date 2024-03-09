// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'check_internet.dart';
// import 'webview/example2.dart';
import 'webview/example3.dart';
import 'webview/example4.dart';
// import 'webview/example5.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final WebExampleThree inAppBrowser = WebExampleThree();
  final WebExampleFour inAppChrome = WebExampleFour();
  String _url = "https://github.com/techwithsam";
  int checkInt = 0;

  double _progress = 0;
  late InAppWebViewController  inAppWebViewController;

  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
        hideUrlBar: false, toolbarTopBackgroundColor: Colors.blue),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        cacheEnabled: true,
        transparentBackground: true,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        print('No internet connect');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No internet connection!'),
        ));
      } else {
        setState(() {
          checkInt = 1;
        });
        print('Internet connected');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connected to the internet'),
        ));
      }
    });
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
      id: 1,
      label: 'Example 1',
      action: (title, url) {
        print(title);
        print(url);
      },
    ));
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
      id: 2,
      label: 'Example 2',
      action: (title, url) {
        print(title);
        print(url);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://pmarket.lpru.ac.th/")
                ),
                onWebViewCreated: (InAppWebViewController controller){
                  inAppWebViewController = controller;
                },
                onProgressChanged: (InAppWebViewController controller , int progress){
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
              _progress < 1 ? Container(
                child: LinearProgressIndicator(
                  value: _progress,
                ),
              ):SizedBox()
            ],

      // body: Center(
      //     child: Column(
      //       children: [
      //         SizedBox(height: 12),
      //         MaterialButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (_) => WebExampleTwo(url: _url),
      //                 ));
      //           },
      //           child: Text(
      //             'Example 2',
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           color: Colors.green,
      //           padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
      //         ),
      //       ],
      //     ),
      //   ),
    )
    );
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
