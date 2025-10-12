import 'package:get/get.dart';
import 'package:odda/app/model/job_type_model.dart';
import 'package:odda/app/provider/api_provider.dart';

class JobTypeRepository {
  late ApiProvider _apiProvider;

  JobTypeRepository() {
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<ModelJobTypes> getJobTypes() async {
    return _apiProvider.getJobTypes(); // call ApiProvider
  }
}
