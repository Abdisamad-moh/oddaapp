import 'package:get/get.dart';
import 'package:odda/app/controller/home_controller.dart';

import '../model/CategoriesData.dart';

class CategoryController extends GetxController{

  final categoriesList = <CategoriesDatum>[].obs;

  @override
  void onInit(){
    super.onInit();
    categoriesList.assignAll(Get.find<HomeController>().categoriesList);
  }

}