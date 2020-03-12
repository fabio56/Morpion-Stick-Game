import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tic_tac_toe/custom_button.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    super.initState();

  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.devit.morpionstickgame';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    void goHomePage(){
      Navigator.pushNamed(context, "/classic");
    }
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton("Classic Game", goHomePage),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton("Online Mode", (){
                    Navigator.pushNamed(context, "/online");
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton("Rate Us",_launchURL)
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton("Share", (){
                  Share.share("Please download my awsesome app to play store :https://play.google.com/store/apps/details?id=com.devit.morpionstickgame ");
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "@ CopyRight fabdev6@gmail.com",
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}

