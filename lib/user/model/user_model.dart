import 'package:flutter_delivery_app/common/model/model_with_id.dart';
import 'package:flutter_delivery_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({required this.message});
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToThumbUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
