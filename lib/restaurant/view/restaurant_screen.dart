import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/secure_storage/secure_storage.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<CursorPagination<RestaurantModel>>(
                    future: ref.watch(restaurantRepositoryProvider).paginate(),
                    builder: (context,
                        AsyncSnapshot<CursorPagination<RestaurantModel>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.separated(
                          itemBuilder: (_, index) {
                            final pItem = snapshot.data!.data[index];

                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => RestaurantDetailScreen(
                                          id: pItem.id)));
                                },
                                child: RestaurantCard.fromModel(model: pItem));
                          },
                          separatorBuilder: (_, index) {
                            return const SizedBox(height: 16.0);
                          },
                          itemCount: snapshot.data!.data.length);
                    }))));
  }
}
