import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLaoding) {
      return const Center(child: CircularProgressIndicator());
    }

    //TODO

    final cp = data as CursorPagination;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: cp.data.length,
          itemBuilder: (_, index) {
            final pItem = cp.data[index];

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(id: pItem.id)));
                },
                child: RestaurantCard.fromModel(model: pItem));
          },
          separatorBuilder: (_, index) {
            return const SizedBox(height: 16.0);
          },
        ));
  }
}
