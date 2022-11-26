import 'package:destributed_tsp/connectors/connector.dart';
import 'package:destributed_tsp/connectors/connector_order.dart';
import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:destributed_tsp/splitters/splitter.dart';
import 'package:destributed_tsp/splitters/splitter_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/pages/page_start.dart';

void main() {
  Get.put(SlavesService());
  Get.put<Splitter>(const OrderSplitter());
  Get.put<Connector>(const OrderConnector());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.purple,
        ),
        useMaterial3: true,
      ).copyWith(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      home: StartPage(
        slavesService: Get.find(),
      ),
    );
  }
}
