import 'package:get/get.dart';
import 'package:todo_list/app/data/services/repository.dart';
import 'package:todo_list/app/data/providers/api_provider.dart';
import 'package:todo_list/app/modules/home/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
        taskRepository: TaskRepository(taskProvider: TaskProvider())));
  }
}
