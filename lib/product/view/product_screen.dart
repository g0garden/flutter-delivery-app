import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/common/component/pagination_list_view.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/product/model/product_model.dart';
import 'package:flutter_delivery_app/product/provider/product_provider.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName,
                    pathParameters: {'rid': model.restaurant.id});
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (_) =>
                //           RestaurantDetailScreen(id: model.restaurant.id)),
                // );
              },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
