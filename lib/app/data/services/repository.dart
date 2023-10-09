
import 'package:todo_list/app/data/models/task.dart';
import 'package:todo_list/app/data/providers/api_provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});
  List<Task> readTask() => taskProvider.readTasks();
  void writeTask(List<Task> tasks) => taskProvider.writeTasks(tasks);
}
