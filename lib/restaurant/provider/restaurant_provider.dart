import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    paginate(); //생성되자마자 pagination 해달라고 constructor에 추가
  }

  //pagination 실행의 값을 반환해주는게 아니라 상태(위의 [])안에다가 우리가 응답받은 리스트로된 RestaurantModel을 전달
  //그러면 위젯에서는 이 상태를 보고 있다가 변경되면 화면에 새로운 값을 렌더링 해줄거
  paginate() async {
    final resp = await repository.paginate();

    state = resp.data;
  }
}
