import 'package:tsp_base/src/models/interface_jsonable.dart';
import 'package:tsp_base/src/models/registery_types.dart';

class ListContent<T extends Jsonable> implements Jsonable {
  static const Type = 'list';
  final List<T> items;

  ListContent(this.items);

  factory ListContent.fromJson(Map<String, dynamic> json) {
    final adaptor = typeMap[json['content-type']]!;
    return ListContent(
      (json['items'] as List).map((j) => adaptor(j) as T).toList().cast(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'content-type' : items.first.type,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String get type => ListContent.Type;
}
