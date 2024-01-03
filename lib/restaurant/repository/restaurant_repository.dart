import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  //http://$ip/restaurant
  //왜 dio를 받아오냐면 =>
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/') //http://$ip/restaurant
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();
  //최고다... 그럼 이제 CursorPagination한테 내가 쓸 모델 타입만 잘 넘겨주면, pagination 할 때 필요한 값까지 다 오케이..
  //이래서 common폴더에 들어갔구만
  //OOP, retrofit, jsonSerializable의 합이 너무 좋네 ㅎㅎ

  @GET('/{id}') //http://$ip/restaurant/:id
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String rid, //rid는 id와 매핑
  });
}
