import 'package:tsp_base/src/models/model_node.dart';
import 'package:kmeans/kmeans.dart';
import 'splitter.dart';

class KMeansSplitter implements Splitter {

  const KMeansSplitter();

  @override
  List<List<Node>> split(List<Node> nodes, int n) {
    final clusters = cluster(nodes, n);
    return clusters.clusterPoints.map(pointsToNodes).toList();
  }

  Clusters cluster(List<Node> nodes, int n) {
    final kmeans = KMeans(nodes.map((v) => [v.x, v.y]).toList());
    final clusters = kmeans.fit(n, maxIterations: 10);
    return clusters;
  }

  List<Node> pointsToNodes(List<List<double>> points) {
    final partitions = points.map((v) => pointToNode(v)).toList();
    return partitions;
  }

  Node pointToNode(List<double> point) {
    return Node(point[0], point[1]);
  }
}
