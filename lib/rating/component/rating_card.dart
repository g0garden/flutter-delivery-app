import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';

class RatingCard extends StatelessWidget {
  //Network
  //AssetImage

  //CircleAvatar 리뷰자 프로필이미지
  final ImageProvider avatarImage;
  //리뷰이미지
  final List<Image> images;
  //별점
  final int rating;
  final String email;
  final String content;

  const RatingCard({
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        _Body(),
        _Images(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header(
      {required this.avatarImage,
      required this.rating,
      required this.email,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
            child: Text(
          email,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),
        )),
        //평점별
        ...List.generate(
            5,
            (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border_outlined,
                  color: PRIMARY_COLOR,
                ))
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Images extends StatelessWidget {
  const _Images({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
