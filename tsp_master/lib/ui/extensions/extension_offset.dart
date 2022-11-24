import 'dart:ui';

import 'package:destributed_tsp/ui/extensions/extension_size.dart';


extension OffsetUtils on Offset {

  Offset scaleBySize(Size size){
    return scaleBy(size.toOffset());
  }

  Offset scaleBy(Offset scale){
    return Offset(dx * scale.dx, dy * scale.dy);
  }
}