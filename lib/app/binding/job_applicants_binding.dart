import 'package:get/get.dart';
import 'package:odda/app/controller/job_applicant_controller.dart';


class JobApplicantsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<JobApplicantsController>(() => JobApplicantsController());
  }
}