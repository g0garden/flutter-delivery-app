import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

//base
abstract class CursorPaginationBase {}

//ERROR
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

//Loading
//data is CursorPaginationLaoding 만 true여도(== 인스턴스만 체크만으로 로딩여부 확인가능)
class CursorPaginationLaoding extends CursorPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;
  //final List<RestaurantModel> data; //이러면 레스토랑모델 타입만 받으니까 다른 pagination할때는?!

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

//새로 고침하기(즉, 이미 데이터 받아왔고 그 후에 다시 새로고침하는 경우)
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  //CursorPaginationRefetching는 CursorPagination을 상속하고, (instance is CursorPagination)
  //CursorPagination이 상속한 CursorPaginationBase도 상속한다. (instance is CursorPaginationBase)
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

//리스트의 맨 아래로 내려서 추가 데이터 요청중일떄
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
