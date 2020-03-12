import 'package:flutter/material.dart';
import 'game_communication.dart';

class GamePage extends StatefulWidget {
  GamePage({
    Key key,
    this.opponentName,
    this.character,
  }): super(key: key);

  ///
  /// Nom de l'adversaire
  ///
  final String opponentName;

  ///
  /// Caratère utilisé pour les jetons du jeu ("X" ou "O")
  ///
  final String character;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  ///
  /// Un jeu consiste en une grille de 3 cases sur 3 cases.
  /// Quand un joueur joue, une de ces cases est remplie avec un "X" ou "O"
  ///
  List<String> grid = <String>["","","","","","","","",""];

  @override
  void initState(){
    super.initState();
    ///
    /// On écoute tous les messages relatifs au jeu+
    ///
    game.addListener(_onAction);
  }

  @override
  void dispose(){
    game.removeListener(_onAction);
    super.dispose();
  }

  /// ---------------------------------------------------------
  /// L'adversaire a émis une action.
  /// Gestion de ces actions.
  /// ---------------------------------------------------------
  _onAction(message){
    switch(message["action"]){
    ///
    /// L'adversaire a démissionné, alors laissons cet écran
    ///
      case 'resigned':
        Navigator.of(context).pop();
        break;

    ///
    /// L'adversaire à joué un coup.
    /// Mémorisons-le et affichons-le sur le plateau
    ///
      case 'play':
        var data = (message["data"] as String).split(';');
        grid[int.parse(data[0])] = data[1];

        // Forcer rafraîchissement
        setState((){});
        break;
    }
  }

  /// ---------------------------------------------------------
  /// Ce joueur rémissionne
  /// Nous devons envoyer une notification à l'adversaire.
  /// Ensuite, nous quittons cet écran.
  /// ---------------------------------------------------------
  _doResign(){
    game.send('resign', '');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Scaffold(
        appBar: new AppBar(
            title: new Text('Game against: ${widget.opponentName}', style: new TextStyle(fontSize: 16.0)),
            actions: <Widget>[
              new RaisedButton(
                onPressed: _doResign,
                child: new Text('Resign'),
              ),
            ]
        ),
        body: _buildBoard(),
      ),
    );
  }

  /// --------------------------------------------------------
  /// Construction du plateau de jeu
  /// --------------------------------------------------------
  Widget _buildBoard(){
    return new SafeArea(
      top: false,
      bottom: false,
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index){
          return _gridItem(index);
        },
      ),
    );
  }

  Widget _gridItem(int index){
    Color color = grid[index] == "X" ? Colors.blue : Colors.red;

    return new InkWell(
      onTap: () {
        ///
        /// Le joueur touche une case.
        /// Si cette dernière est vide, nous la remplissons
        /// avec le caractère du joueur et notifions son adversaire.
        /// Nous rafraîchissons le plateau de jeu
        ///
        if (grid[index] == ""){
          grid[index] = widget.character;

          ///
          /// Pour envoyer un mouvement, nous fournissons le numéro
          /// de la case et le caractère des jetons du joueur
          ///
          game.send('play', '$index;${widget.character}');

          /// Forcer le rafraîchissement du plateau
          setState((){});
        }
      },
      child: new GridTile(
        child: new Card(
          child: new FittedBox(
              fit: BoxFit.contain,
              child: new Text(grid[index], style: new TextStyle(fontSize: 50.0, color: color,))
          ),
        ),
      ),
    );
  }
}