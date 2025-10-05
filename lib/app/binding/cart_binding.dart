import 'package:get/get.dart';
import 'package:odda/app/controller/cart_controller.dart';


class CartBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
          () => CartController(),
    );
  }
}