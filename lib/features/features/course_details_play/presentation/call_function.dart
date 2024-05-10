import 'package:interective_cares_task/features/features/course_details_play/domain/repository/course_repository.dart';
import 'package:interective_cares_task/features/features/course_details_play/domain/usecase/course_usecase.dart';

import '../../../../core/app_component/app_component.dart';
import '../data/services/course_services.dart';
import '../domain/usecase/course_pass_usecase.dart';

class DataFetchFunction{
  var dataList = <dynamic>[];
  Future<List<dynamic>> fetchAllApplicantData({required String mainCollectionName, required String nestedCollectionName}) async {
    try {
      final questionPassUseCase = CourseDetailsPassUseCase(locator<CourseDetailsRepository>());
      var response = await questionPassUseCase(mainCollectionName: mainCollectionName, nestedCollectionName: nestedCollectionName);

      // Additional logic based on the response
      if (response != null) {
        // Assuming response is a List<dynamic>, modify as needed
        dataList.addAll(response);
      }
    } catch (error) {
      print("Error loading data: $error");
      // Handle errors here, if needed
    }

    return dataList;
  }
}