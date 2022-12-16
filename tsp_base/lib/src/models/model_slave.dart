import 'dart:async';


import 'model_message.dart';

class Slave {
  static final Type = 'slave';
  final String id;
  final receiveController = StreamController<Message>.broadcast(sync: true);
  final sendController = StreamController<Message>.broadcast(sync: true);

  Slave(this.id);

}
