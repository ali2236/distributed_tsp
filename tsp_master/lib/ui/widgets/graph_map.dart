import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';

import '../painters/paint_graph.dart';

class GraphMap extends StatefulWidget {
  final Dataset dataset;
  final Size size;

  const GraphMap({
    Key? key,
    required this.dataset,
    required this.size,
  }) : super(key: key);

  @override
  State<GraphMap> createState() => _GraphMapState();
}

class _GraphMapState extends State<GraphMap> {
  @override
  void initState() {
    super.initState();
    widget.dataset.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: GraphPainter(
        dataset: widget.dataset,
        dotColor: Theme.of(context).colorScheme.primary,
        lineColor: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
