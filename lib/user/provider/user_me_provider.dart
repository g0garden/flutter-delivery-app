import 'dart:async';

import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/secure_storage/secure_storage.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_delivery_app/user/repository/auth_repository.dart';
import 'package:flutter_delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final repository = ref.watch(userMeRepositoryProvier);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
      storage: storage, authRepository: authRepository, repository: repository);
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.storage,
    required this.authRepository,
    required this.repository,
  }) : super(UserModelLoading()) {
    //내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    //토큰들 중에 하나라도 없으면 요청할것도 없음
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp as UserModelBase?;
  }

  Future<UserModelBase?> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp =
          await authRepository.login(username: username, password: password);

      //token 잘 발급받아서 storage잘 저장하고
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      // state에 로그인 잘 된 유저정보 넣어줘야지
      final userResp = await repository.getMe();

      state = userResp;
      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
