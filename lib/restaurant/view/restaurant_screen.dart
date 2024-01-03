import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder(
                    future: paginateRestaurant(),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      // print(snapshot.error);
                      // print(snapshot.data);

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.separated(
                          itemBuilder: (_, index) {
                            final item = snapshot.data![index];
                            final pItem = RestaurantModel.fromJson(item);

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
                          itemCount: snapshot.data!.length);
                    }))));
  }
}
