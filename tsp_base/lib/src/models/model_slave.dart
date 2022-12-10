import 'dart:async';


import 'model_message.dart';

class Slave {
  static final Type = 'slave';
  final String id;
  final receiveController = StreamController<Message>.broadcast();
  final sendController = StreamController<Message>.broadcast();

  Slave(this.id);

}
