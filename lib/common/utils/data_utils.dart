import 'package:flutter_delivery_app/common/const/data.dart';

class DataUtils {
  static pathToThumbUrl(String value) {
    return 'http://$ip${value}';
  }

  static listPathsToUrls(List paths) {
    return paths.map((e) => pathToThumbUrl(e).toList);
  }
}
