import 'package:get/get.dart';
import 'package:odda/app/controller/address_controller.dart';

class AddressBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(
          () => AddressController(),
    );
  }
}