import '../../../../../../core/data/model/api_response.dart';
// import '../../domain/repository/course_repository.dart';
import '../../domain/repository/course_repository.dart';

import '../services/course_services.dart';

class CourseDetailsRepositoryImplement extends CourseDetailsRepository {
  CourseDetailsRepositoryImplement(CourseDetailsServices fetchDataServices)
      : super(fetchDataServices);

  @override
  Future<List<dynamic>> fetchDataPass({required String mainCollectionName, required String nestedCollectionName}) async {
    return fetchDataServices.fetchData(mainCollectionName: mainCollectionName, nestedCollectionName: nestedCollectionName);
  }
}