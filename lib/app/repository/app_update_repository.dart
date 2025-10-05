import 'package:get/get.dart';
import 'package:odda/app/model/update_app_data.dart';
import 'package:odda/app/provider/api_provider.dart';


class UpdateAppRepository{

  late ApiProvider _apiProvider;

  UpdateAppRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<UpdateAppData> getUpdateApp() async {
    return _apiProvider.getUpdateApp();
  }

}