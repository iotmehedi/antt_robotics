
import '../../../../../../core/data/model/api_response.dart';
import '../../data/model/course_model.dart';
import 'course_usecase.dart';

class CourseDetailsPassUseCase extends CourseDetailsUseCase {
  CourseDetailsPassUseCase(super.jsonTaskRepository);

  Future<List<dynamic>> call({required String mainCollectionName, required String nestedCollectionName}) async {
    return await jsonTaskRepository.fetchDataPass(mainCollectionName: mainCollectionName, nestedCollectionName: nestedCollectionName);
  }
}