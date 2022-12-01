import 'dart:io';

import 'package:tsp_slave/services/service_master.dart';

void main(List<String> arguments) async {
  const defaultUrl = 'localhost:2022';
  stdout.write('Enter Master Url(default=$defaultUrl):');
  final input = stdin.readLineSync();
  final url = (input?.isNotEmpty ?? false) ? input : defaultUrl;
  await MasterService.create(url!);
  print('connected');
}
