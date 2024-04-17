import 'package:flutter/foundation.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_delivery_app/common/view/splash_screen.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter_delivery_app/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authPrivider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      //userMeProvider 에서 변경사항이 생겼을때만 AuthProvider도 변경사항 생겼네? 하고 처리하도록
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  //GoRouter 의 Routes...
  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, state) => RootTab(),
            routes: [
              GoRoute(
                  path: 'restaurant/:rid',
                  builder: (_, state) =>
                      RestaurantDetailScreen(id: state.pathParameters['rid']!))
            ]),
        GoRoute(
            path: '/splash',
            name: SplashScreen.routeName,
            builder: (_, state) => SplashScreen()),
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            builder: (_, state) => LoginScreen())
      ];

  //redirect 로직!!
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.uri == '/login';

    //유저 정보 없는데
    //로그인 중이면 그대로 로그인페이지 있으면 되고
    //만약에 로그인중 아니면 로그인 페이지 가서 유저정보 제대로 가져왕
    if (user == null) {
      return logginIn ? null : '/login';
    }

    //user가 null 아님

    //UserModel
    //사용자 정보가 있는 상태면
    //로그인 중이거나 현재 위치가 splah면
    //홈으로 이동

    if (user is UserModel) {
      return logginIn || state.uri == '/splash' ? '/' : null;
    }

    //usermodelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
