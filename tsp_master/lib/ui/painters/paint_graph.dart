import 'dart:math';
import 'package:destributed_tsp/ui/extensions/extension_offset.dart';
import 'package:destributed_tsp/ui/extensions/extension_point.dart';
import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';

class GraphPainter extends CustomPainter {
  final Dataset dataset;
  final Color dotColor, lineColor;

  const GraphPainter({
    required this.dataset,
    required this.dotColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = dataset.nodes.length;
    final nodePaint = Paint()..color = dotColor;
    final edgePaint = Paint()
      ..color = lineColor
      ..strokeWidth = (0.005 * size.width) / log(n);

    // edges
    for (var edgePartition in dataset.edgePartition) {
      for(var edge in edgePartition){
        canvas.drawLine(
          edge.firstNode.offset.scaleBySize(size),
          edge.secondNode.offset.scaleBySize(size),
          edgePaint,
        );
      }
    }

    // nodes
    for (var node in dataset.nodes) {
      canvas.drawCircle(
        node.offset.scaleBySize(size),
        (0.02 * size.width) / log(n),
        nodePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
