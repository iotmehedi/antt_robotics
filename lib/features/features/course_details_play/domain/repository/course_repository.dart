
import '../../../../../core/data/model/api_response.dart';
import '../../data/model/course_model.dart';
import '../../data/services/course_services.dart';

abstract class CourseDetailsRepository {
  final CourseDetailsServices fetchDataServices;

  CourseDetailsRepository(this.fetchDataServices);

  Future<List<dynamic>> fetchDataPass({required String mainCollectionName, required String nestedCollectionName});
}