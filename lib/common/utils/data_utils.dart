import 'dart:convert';

import 'package:flutter_delivery_app/common/const/data.dart';

class DataUtils {
  static pathToThumbUrl(String value) {
    return 'http://$ip${value}';
  }

  static listPathsToUrls(List paths) {
    return paths.map((e) => pathToThumbUrl(e).toList);
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}
