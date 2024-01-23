import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void paginate({
    int fetchCount = 20,
    //true - 새로고침(데이터 있는 현재상태에서), false- 추가로 더 가져오기
    bool fetchMore = false,
    //강제로 다시 로딩하기
    //걍 다시 시작, true - CursorPaginationLoading부터시작
    bool forceRefetch = false,
  }) async {
    //5가지 가능성 = 상태의 5가지 상태

    //1) CursorPagination - 정상적으로 데이터 있는 상태
    //2) CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음)
    //3) CursorPaginationError - 에러있을 때
    //4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터 가져올때
    //5) CursorPaginationFetchMore - 추가 데이터를 paginate해오라는 요청 받았을때

    //바로 반환하는 상황부터 코딩해보자
    //1) hasMore = false(기존상태에서 더 가져올거 없음)
    //2) 로딩중 - fetchMore : true (이미 로딩중 = 가져오고 있는데, 또 요청해? 그럼 같은거 또 들고올수있자나)
    //3) 로딩중 - fetchMore : false (이미 로딩중 = 가져오고 있는데, 더 fetch를 요청하는게 아니라 다른 요청? => 그냥 위로가서 새로고침하는걸 수 있음. 그럼해야지)

    if (state is CursorPagination && !forceRefetch) {
      //우리가 애초에 CursorPaginationBase 타입을 받으니까,
      //state는 CursorPagination 라고 명시해줘여함.
      final pState = state as CursorPagination;

      if (!pState.meta.hasMore) {
        return;
      }
    }
  }
}
