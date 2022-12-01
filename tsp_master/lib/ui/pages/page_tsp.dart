import 'package:destributed_tsp/ui/controllers/controller_tsp.dart';
import 'package:destributed_tsp/ui/widgets/graph_map.dart';
import 'package:flutter/material.dart';


class TspPage extends StatelessWidget {
  final TspController manager;

  const TspPage({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    manager.solve();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            manager.cancel();
            Navigator.pop(context);
          },
        ),
        title: const Text('TSP'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GraphMap(
            dataset: manager.dataset,
            size: constraints.biggest,
          ),
        );
      }),
    );
  }
}
