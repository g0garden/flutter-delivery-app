import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> {
  final CursorPaginationMeta meta;
  final List<T> data;
  //final List<RestaurantModel> data; //이러면 레스토랑모델 타입만 받으니까 다른 pagination할때는?!

  CursorPagination({required this.meta, required this.data});

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}
