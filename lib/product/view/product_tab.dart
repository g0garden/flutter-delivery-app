import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/product/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductTab extends ConsumerStatefulWidget {
  const ProductTab({super.key});

  @override
  ConsumerState<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends ConsumerState<ProductTab> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);

    return Center(
      child: Text('음식'),
    );
  }
}
