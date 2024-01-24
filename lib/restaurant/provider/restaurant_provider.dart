import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//반환하는 값은 RestaurantModel, family로 입력하는 값은 레스토랑 id
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
class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLaoding()) {
    paginate(); //생성되자마자 pagination 해달라고 constructor에 추가
  }

  //pagination 실행의 값을 반환해주는게 아니라 상태(위의 [])안에다가 우리가 응답받은 리스트로된 RestaurantModel을 전달
  //그러면 위젯에서는 이 상태를 보고 있다가 변경되면 화면에 새로운 값을 렌더링 해줄거
  Future<void> paginate({
    int fetchCount = 20,
    //true - 새로고침(데이터 있는 현재상태에서), false- 추가로 더 가져오기
    bool fetchMore = false,
    //강제로 다시 로딩하기
    //걍 다시 시작, true - CursorPaginationLoading부터시작
    bool forceRefetch = false,
  }) async {
    try {
      //5가지 가능성 = 상태의 5가지 상태

      //1) CursorPagination - 정상적으로 데이터 있는 상태
      //2) CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음)
      //3) CursorPaginationError - 에러있을 때
      //4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터 가져올때
      //5) CursorPaginationFetchMore - 추가 데이터를 paginate해오라는 요청 받았을때

      //바로 반환하는 상황부터 코딩해보자
      //1) hasMore = false(기존상태에서 더 가져올거 없음)
      //2) 로딩중 - fetchMore : true (이미 로딩중 = 가져오고 있는데, 또 요청해? 그럼 같은거 또 들고올수있자나)
      //   로딩중 - fetchMore : false (이미 로딩중 = 가져오고 있는데, 더 fetch를 요청하는게 아니라 다른 요청? => 그냥 위로가서 새로고침하는걸 수 있음. 그럼해야지)

      if (state is CursorPagination && !forceRefetch) {
        //우리가 애초에 CursorPaginationBase 타입을 받으니까,
        //state는 CursorPagination 라고 명시해줘여함.
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLaoding;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      //PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      //fetch more 데이터 추가로 더 가져오기~
      if (fetchMore) {
        //fetchMore가 true라는 거 자체가 CursorPagination의 data가 있다는 거니까, 100프로 확신하니까 casting하는 거임
        //state는 CursorPagination의 인스턴스이다.
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        //데이터 처음부터 가져오는 상황
        //만약 데이터 있는상황이며느 기존 데이터는 보존한채로 Fetch(API 요청) 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLaoding();
        }
      }

      //가장 최신 데이터
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        //기존 데이터 + 방금 추가로 받아온 최신데이터 합쳐주기
        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
      } else {
        //처음 20개
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(
        message: '데이터를 가져오지 못했습니다.',
      );
    }
  }

  //
  getDatail({
    required String id,
  }) async {
    //만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
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
