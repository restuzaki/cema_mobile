import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../service/authenticated_client.dart';

class AddTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticatedClient>(() => AuthenticatedClient());
    Get.lazyPut<TaskRepository>(
      () => TaskRepository(client: Get.find<AuthenticatedClient>()),
    );
    Get.lazyPut<ProjectRepository>(
      () => ProjectRepository(client: Get.find<AuthenticatedClient>()),
    );
    Get.lazyPut<AddTaskController>(() => AddTaskController());
  }
}
