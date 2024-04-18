import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/component/custom_text_form_field.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_delivery_app/user/model/user_model.dart';
import 'package:flutter_delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
          .onDrag, // 키보드 자판 나왔다가 화면 드래그하면 키보드 사라지도록
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              const _Title(),
              const SizedBox(height: 16.0),
              const _SubTitle(),
              Image.asset(
                'asset/img/misc/logo.png',
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
              CustomTextFormField(
                hintText: "이메일을 입력해주세요",
                onChanged: (String value) {
                  username = value;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hintText: "비밀번호를 입력해주세요",
                onChanged: (String value) {
                  password = value;
                },
                obscureText: true,
              ),
              ElevatedButton(
                //login중이면 로그인 버튼 못누르게!
                onPressed: state is UserModelLoading
                    ? null
                    : () async {
                        ref
                            .read(userMeProvider.notifier)
                            .login(username: username, password: password);

                        //final rawString = 'test@codefactory.ai:testtest';
                        // final rawString = '$username:$password';

                        // final storage = ref.read(secureStorageProvider);

                        // await storage.write(
                        //     key: REFRESH_TOKEN_KEY, value: refreshToken);
                        // await storage.write(
                        //     key: ACCESS_TOKEN_KEY, value: accessToken);

                        //로그인 성공했으면 RootTab으로 이동
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => RootTab()));
                      },
                style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                child: const Text('로그인'),
              ),
              TextButton(
                onPressed: () async {},
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('회원가입'),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome!",
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w300, color: BODY_TEXT_COLOR),
    );
  }
}
