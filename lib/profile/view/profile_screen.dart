import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/user/provider/auth_provider.dart';
import 'package:flutter_delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        child: Center(
            child: ElevatedButton(
      onPressed: () {
        ref.read(userMeProvider.notifier).logout();
      },
      child: Text('로그아웃'),
    )));
  }
}
