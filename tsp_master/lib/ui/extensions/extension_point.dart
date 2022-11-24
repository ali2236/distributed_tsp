import 'dart:ui';

import 'package:tsp_base/core.dart';

extension NodeOffset on Node {
  Offset get offset => Offset(x, y);
}
