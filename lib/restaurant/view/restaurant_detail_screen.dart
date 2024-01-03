import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, super.key});

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant/$id',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '불타는 떡볶이',
        child: FutureBuilder<Map<String, dynamic>>(
            future: getRestaurantDetail(),
            builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = RestaurantDetailModel.fromJson(snapshot.data!);

              return CustomScrollView(
                slivers: [
                  rendertop(model: item),
                  renderLabel(),
                  renderProducts(products: item.products)
                ],
              );
            }));
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
          child: Text("메뉴",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500))),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];
          return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model));
        },
        childCount: products.length,
      )),
    );
  }

  SliverToBoxAdapter rendertop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
        child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ));
  }

  // SliverToBoxAdapter renderTop() {
  //   return SliverToBoxAdapter(
  //       child: Column(
  //     children: [
  //       RestaurantCard(
  //         image: Image.asset('asset/img/food/pizza_ddeok_bok_gi.jpg'),
  //         name: "불타는 떡볶이",
  //         tags: ["", "", "hot"],
  //         ratingsCount: 100,
  //         deliveryTime: 30,
  //         delivertFee: 3000,
  //         ratings: 4.7,
  //         isDetail: true,
  //         detail: "굿굿굿",
  //       ),
  //       Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //           child: ProductCard())
  //     ],
  //   ));
  // }
}
