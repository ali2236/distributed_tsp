import 'dart:async';


import 'model_message.dart';

class Slave {
  static final Type = 'slave';
  final String id;
  void Function(Message msg)? receiver;
  void Function(Message msg)? sender;

  Slave(this.id);

}
