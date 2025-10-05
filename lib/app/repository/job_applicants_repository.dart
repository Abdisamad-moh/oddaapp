import 'package:get/get.dart';
import 'package:odda/app/model/job_applicants_model.dart';
import 'package:odda/app/provider/api_provider.dart';

class JobApplicantsRepository{
  late ApiProvider _apiProvider;

  JobApplicantsRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }
  Future<ModelJobApplicants> getJobApplicants(int jobType) async {
    return _apiProvider.getJobApplicants(jobType);
  }

}