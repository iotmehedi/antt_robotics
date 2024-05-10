import 'package:get_it/get_it.dart';
import 'package:interective_cares_task/features/features/course_details_play/data/repository_implement/course_repository_implement.dart';

import '../../features/features/course_details_play/data/services/course_services.dart';
import '../../features/features/course_details_play/domain/repository/course_repository.dart';



final locator = GetIt.instance;

Future<void> init() async {
  locator.registerFactory<CourseDetailsServices>(() => CourseDetailsServices());
  locator.registerFactory<CourseDetailsRepository>(() => CourseDetailsRepositoryImplement(locator()));
}