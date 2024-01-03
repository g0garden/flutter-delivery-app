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

    //진짜 요청시작!
    return super.onRequest(options, handler);
  }
//2) 응답받을때

  //3) 에러났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 (만료되거나)
    //토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    //다시 새로운 토큰으로 요청을 한다.
    print('[ERROR] [${err.requestOptions.method} ${err.requestOptions.uri}]');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken도 만료되었으면
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; //토큰 발급자체에 문제가있네

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post('http://$ip/auth/token',
            options:
                Options(headers: {'authorization': 'Bearer $refreshToken'}));

        final accessToken = resp.data['accessToken'];

        //이 에러를 발생시킨 요청의 옵션들!
        final options = err.requestOptions;
        //받아온 엑세스토큰을 헤더에 넣어서 전달하고
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        //스토리지에도 넣어놔야 다음 다른 요청에서도 잘 가져다 씀.
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송! 에러가 위의 작업들로 잘 수정되었을테니까 요청 다시 보내는거
        final response = await dio.fetch(options);

        //에러가 났지만, 결과적으로는 재요청으로 성공적인 응답을 리턴해줄수있음
        //화면에서는 이 성공적인 응답만 보고 에러난지 모를듯.
        return handler.resolve(response);
      } on DioException catch (e) {
        //어떤 이유든 여기서 에러났으면, 더 이상 토큰 발급받을 상황 아니지
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
