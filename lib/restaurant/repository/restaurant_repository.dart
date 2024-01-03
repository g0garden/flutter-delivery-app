import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  //http://$ip/restaurant
  //왜 dio를 받아오냐면 =>
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  //pagenation 일반화하는라 특이하게 작성한 케이스
  // @GET('/') //http://$ip/restaurant
  // paginate();

  @GET('/{id}') //http://$ip/restaurant/:id
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String rid, //rid는 id와 매핑
  });
}
