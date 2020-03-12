import 'package:flutter/material.dart';
import 'game_communication.dart';
import 'online_mode.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  static final TextEditingController _name = new TextEditingController();
  String playerName;
  List<dynamic> playersList = <dynamic>[];

  @override
  void initState() {
    super.initState();
    ///
    /// Demandons d'être notifié pour chaque message
    /// envoyé par le serveur
    ///
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// Cette routine gère tous les messages envoyés par le serveur.
  /// Seules les 2 actions suivantes, sont d'utilité dans cette page
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _onGameDataReceived(message) {
    switch (message["action"]) {
    ///
    /// A chaque fois qu'un utilisateur rejoint, nous devons
    ///   * enregistrer la nouvelle liste de joueurs
    ///   * rafraîchir la liste des joueurs
    ///
      case "players_list":
        playersList = message["data"];

        // force rafraîchissement
        setState(() {});
        break;

    ///
    /// Quand une partie est démarrée par un autre joueur,
    /// nous acceptons la partie et nous dirigeons vers
    /// l'écran 2 (jeu)
    /// Comme nous ne sommes pas l'initiateur du jeu,
    /// nous utiliserons les "O" pour jouer
    ///
      case 'new_game':
        Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
          => new GamePage(
            opponentName: message["data"], // Nom de l'adversaire
            character: 'O',
          ),
        ));
        break;
    }
  }

  /// -----------------------------------------------------------
  /// Lorsque l'utilisateur n'a pas encore rejoint, nous le
  /// laissons introduire son nom et rejoindre la liste des
  /// joueurs
  /// -----------------------------------------------------------
  Widget _buildJoin() {
    if (game.playerName != "") {
      return new Container();
    }
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter your name',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: _onGameJoin,
              child: new Text('Join...'),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------
  /// L'utilisateur veut rejoindre.  Envoyons son nom.
  /// Maintenant que nous avons le nom du joueur, nous
  /// pouvons afficher la liste des tous les joueurs.
  /// ------------------------------------------------------
  _onGameJoin() {
    game.send('join', _name.text);

    /// Forcer un rafraîchissement
    setState(() {});
  }

  /// ------------------------------------------------------
  /// Construction de la liste des joueurs
  /// ------------------------------------------------------
  Widget _playersList() {
    ///
    /// Si l'utilisateur n'a pas encore rejoint,
    /// nous n'affichons pas la liste des tous les joueurs
    ///
    if (game.playerName == "") {
      return new Container();
    }

    ///
    /// Affichage de la liste des joueurs...
    /// Pour chaque joueur, un bouton permet de lancer
    /// une nouvelle partie
    ///
    List<Widget> children = playersList.map((playerInfo) {
      return new ListTile(
        title: new Text(playerInfo["name"]),
        trailing: new RaisedButton(
          onPressed: (){
            _onPlayGame(playerInfo["name"], playerInfo["id"]);
          },
          child: new Text('Play'),
        ),
      );
    }).toList();

    return new Column(
      children: children,
    );
  }

  /// --------------------------------------------------------------
  /// Nous lançons une nouvelle partie.  Nous devons:
  ///    * envoyer l'action "new_game", en même temps que
  ///      l'identifiant unique de l'adversaire choisi
  ///    * rediriger vers le plateau de jeu
  ///      Comme nous sommes l'initiateur du jeu, nous jouerons
  //       avec les "X"
  /// --------------------------------------------------------------
  _onPlayGame(String opponentName, String opponentId){
    // Nous devons envoyer l'identité de l'adversaire
    game.send('new_game', opponentId);

    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context)
      => new GamePage(
        opponentName: opponentName,
        character: 'X',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('TicTacToe'),
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildJoin(),
              new Text('List of players:'),
              _playersList(),
            ],
          ),
        ),
      ),
    );
  }
}