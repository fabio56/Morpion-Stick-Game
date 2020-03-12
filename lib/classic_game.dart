import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/custom_dialog.dart';
import 'package:tic_tac_toe/game_button.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = "Mobile_id";

class ClassicGame extends StatefulWidget {
  @override
  _ClassicGameState createState() => _ClassicGameState();
}

class _ClassicGameState extends State<ClassicGame> {
  int _count = 0 ;
  bool interLoad = false;
  bool bannerLoad = false;
  BannerAd _bannerAd;

  InterstitialAd myInterstitial;
  InterstitialAd createInterAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-4383708983412360/7767992730",
        listener: (MobileAdEvent event ){
          if (event == MobileAdEvent.loaded){
            setState(() {
              interLoad = true ;
            });
          }
          if (event == MobileAdEvent.closed){
            setState(() {
              interLoad = false ;
            });
          }
          print("BannerAd $event");
        }
    );
  }

  BannerAd createBanneraAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-4383708983412360/3754447334",
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            setState(() {
              bannerLoad = true;
            });
          }
          if (event == MobileAdEvent.closed) {
            setState(() {
              bannerLoad = false;
            });
          }
          print("BannerAd $event");
        });
  }

  bool boardIsFull;
  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  @override
  void initState() {
    boardIsFull = false;
    player1 = List();
    player2 = List();
    activePlayer = 1;
    buttonsList = doInit();
    _bannerAd = createBanneraAd()..load()..show();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    super.initState();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        setState(() {
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    myInterstitial.dispose();
    super.dispose();
  }

  List<GameButton> doInit() {
    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "0";
        gb.bg = Colors.blue;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      checkWinner();
  });
  myInterstitial = createInterAd()..load();
  RewardedVideoAd.instance.load(adUnitId: "ca-app-pub-4383708983412360/8889502716");
  }

  bool CheckboardFull() {
    for (int i = 0; i < buttonsList.length; i++) {
      if (buttonsList[i].enabled == true) {
        return false;
      }
    }
    return true;
  }

  void checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }
    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }
    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                  "Player 1 won ",
                  "Press the reset button to start again",
                  newGame,
                ));
        winner = -1;
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                  "Player 2 won ",
                  "Press the reset button to start again",
                  newGame,
                ));
        winner = -1;
      }
    } else {
      boardIsFull = CheckboardFull();
      if (boardIsFull == true) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                  "Match is null",
                  "Press the reset button to start again",
                  newGame,
                ));
      }
    }
  }
  void newGame (){
    setState(() {
      _count++ ;
    });

    if(_count%2  == 0 && interLoad) {
      myInterstitial
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );
    }else if (_count%5 == 0 ){
      RewardedVideoAd.instance.show();
    }
    resetGame();

  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      boardIsFull = false;
      player1 = List();
      player2 = List();
      activePlayer = 1;
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TIC TAC TOE "),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                padding: const EdgeInsets.all(10.0),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => SizedBox(
                  width: 100,
                  height: 100,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: buttonsList[i].enabled
                        ? () => playGame(buttonsList[i])
                        : null,
                    child: Text(
                      buttonsList[i].text,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: buttonsList[i].bg,
                    disabledColor: buttonsList[i].bg,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: bannerLoad ? 50 : 0),
              child: RaisedButton(
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.blueAccent,
                padding: EdgeInsets.all(20.0),
                onPressed: resetGame,
              ),
            )
          ],
        ));
  }
}
