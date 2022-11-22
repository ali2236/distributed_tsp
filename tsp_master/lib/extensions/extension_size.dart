import 'dart:ui';

extension SizeUtils on Size {
  Offset toOffset(){
    return Offset(width, height);
  }
}