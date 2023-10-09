import 'dart:convert';

import 'package:get/get.dart';
import 'package:todo_list/app/core/utils/keys.dart';
import 'package:todo_list/app/data/models/task.dart';
import 'package:todo_list/app/data/services/service.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();

  // {'tasks': [
  //   {
  //     'title' : 'work',
  //     'color': '#ff123456',
  //     'icon' : '0xe123'}
  // ]}

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }

  void writeTasks(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
