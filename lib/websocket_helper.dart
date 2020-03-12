import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

///
/// Variable globale d'accès aux WebSockets
///
WebSocketsNotifications sockets = new WebSocketsNotifications();

///
/// Remplacez la ligne suivante par l'adresse IP et le numéro de port de votre serveur
///
const String _SERVER_ADDRESS = "ws://morpionstick.herokuapp.com";

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets = new WebSocketsNotifications._internal();

  factory WebSocketsNotifications(){
    return _sockets;
  }

  WebSocketsNotifications._internal();

  ///
  /// Le canal de communication WebSocket
  ///
  IOWebSocketChannel _channel;

  ///
  /// La connexion est-elle établie ?
  ///
  bool _isOn = false;

  ///
  /// Listeners
  /// Liste des méthodes à appeler à chaque fois d'un message est reçu
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ----------------------------------------------------------
  /// Initialisation de la connexion WebSockets avec le serveur
  /// ----------------------------------------------------------
  initCommunication() async {
    ///
    /// Juste au cas..., ferture d'un autre connexion
    ///
    reset();

    ///
    /// Ouvrir une nouvelle communication WebSockets
    ///
    try {
      _channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);

      ///
      /// Démarrage de l'écoute des nouveaux messages
      ///
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch(e){
      ///
      /// Gestion des erreurs globales
      /// TODO
      ///
    }
  }

  /// ----------------------------------------------------------
  /// Fermer la communication WebSockets
  /// ----------------------------------------------------------
  reset(){
    if (_channel != null){
      if (_channel.sink != null){
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  /// ---------------------------------------------------------
  /// Envoie un message au serveur
  /// ---------------------------------------------------------
  send(String message){
    if (_channel != null){
      if (_channel.sink != null && _isOn){
        _channel.sink.add(message);
      }
    }
  }

  /// ---------------------------------------------------------
  /// Gestion des routines à appeler lors de la réception
  /// des messages issus du serveur
  /// ---------------------------------------------------------
  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Appel de toutes les méthodes à l'écoute des messages entrants
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message){
    _isOn = true;
    _listeners.forEach((Function callback){
      callback(message);
    });
  }
}