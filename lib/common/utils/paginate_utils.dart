import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    //현재위치가 최대길이보다 조금 덜되는 위치까지 왔다면 새로운 데이터 추가요청하기
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }
}
