import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//우리가 받을 값은 RestaurantModel, family로 입력하는 값은 레스토랑 id
final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    //CursorPagination아니라는 것은 state(restaurantProvider)에 데이터 없음
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

//2. StateNotifier Provider에 연결
final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(
    repository: repository,
  );

  return notifier;
});

//1. StateNotifier 생성
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  getDatail({
    required String id,
  }) async {
    //만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    //state가 Cursorpagination이 아닐때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    //위에서 Cursorpagination아닐 경우 다 걸렀으니까
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(rid: id);

    //[RestaurantModel(1), RestaurantModel(2),RestaurantModel(3)]
    //id: 2인 모델의 Detail모델을 가져와라
    // getRestaurantDetail(id:2)
    //[RestaurantModel(1), RestaurantDetailModel(2),RestaurantModel(3)]
    state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
            )
            .toList());
  }
}
