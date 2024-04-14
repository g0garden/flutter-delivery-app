import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/common/component/pagination_list_view.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/product/model/product_model.dart';
import 'package:flutter_delivery_app/product/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return ProductCard.fromProductModel(model: model);
        });
  }
}
