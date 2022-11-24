import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/pages/page_start.dart';

void main() {
  Get.put(SlavesService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(
        slavesService: Get.find(),
      ),
    );
  }
}
