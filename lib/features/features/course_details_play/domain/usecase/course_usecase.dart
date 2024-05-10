import '../repository/course_repository.dart';

abstract class CourseDetailsUseCase {
  final CourseDetailsRepository jsonTaskRepository;

  CourseDetailsUseCase(this.jsonTaskRepository);
}