import 'package:get/get.dart';

import '../controller/vendor_products_controller.dart';

class VendorProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<VendorProductsController>(() => VendorProductsController());
  }
}