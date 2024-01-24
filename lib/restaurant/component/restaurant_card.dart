import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int delivertFee;
  final double ratings;
  final bool isDetail;
  final String? heroKey;
  final String? detail;

  const RestaurantCard(
      {required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.delivertFee,
      required this.ratings,
      this.isDetail = false,
      this.heroKey,
      this.detail,
      Key? key})
      : super(key: key);

  //factory constructor 활용
  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      delivertFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      heroKey: model.id,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heroKey != null)
            Hero(
              tag: ObjectKey(heroKey),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
                  child: image),
            ),
          if (heroKey == null)
            ClipRRect(
                borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
                child: image),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  tags.join(' · '),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Row(children: [
                  _IconText(icon: Icons.star, label: ratings.toString()),
                  renderDot(),
                  _IconText(
                      icon: Icons.receipt, label: ratingsCount.toString()),
                  renderDot(),
                  _IconText(
                      icon: Icons.timelapse_outlined, label: '$deliveryTime 분'),
                  renderDot(),
                  _IconText(
                      icon: Icons.monetization_on,
                      label: delivertFee == 0 ? '무료' : delivertFee.toString()),
                ]),
                if (detail != null && isDetail)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(detail!),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget renderDot() {
  return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '·',
        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      ));
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: PRIMARY_COLOR, size: 14.0),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(fontSize: 12.0, color: BODY_TEXT_COLOR),
        )
      ],
    );
  }
}
