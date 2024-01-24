import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/dio/dio.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantDetailProvider(id));

    if (state == null) {
      return const DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return DefaultLayout(
        title: '불타는 떡볶이',
        child: CustomScrollView(
          slivers: [
            rendertop(model: state),
            // renderLabel(),
            // renderProducts(products: snapshot.data!.products)
          ],
        ));
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
    required RestaurantModel model,
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
