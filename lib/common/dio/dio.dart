import 'package:dio/dio.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  //1) 요청보낼때
  // 요청 보낼때마다
  // 만약 요청의 header에 'accessToken': 'true'라는 값이 있으면
  // storage의 실제 토큰을 'authorization': 'Bearer $token'으로 헤더를 변경한다.
  // 왜?? 매번 모든 토큰이 필요한 요청의 repo에 다 넣어줄 수 없으니까

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //print('[REQ] [${options.method} ${options.uri}]');

    if (options.headers['accessToken'] == 'true') {
      //'accessToken': 'true' 삭제 후
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //'authorization': 'Bearer $token' storage에서 가져 온 진짜 토큰값
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      //'accessToken': 'true' 삭제 후
      options.headers.remove('refreshToken');

      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      //'authorization': 'Bearer $token' storage에서 가져 온 진짜 토큰값
      options.headers.addAll({'authorization': 'Bearer $refreshToken'});
    }

    return super.onRequest(options, handler);
  }
//2) 응답받을때
//3) 에러났을때
}
