import 'package:get/get.dart';
import 'package:odda/app/controller/order_report_controller.dart';


class OrderReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<OrderReportController>(
          () => OrderReportController(),
    );
  }
}