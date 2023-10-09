import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_list/app/data/services/service.dart';
import 'package:todo_list/app/modules/home/binding.dart';
import 'package:todo_list/app/modules/home/view.dart';

void main() async {
  await GetStorage.init();
  //return storage service instance
  await Get.putAsync(() => StorageService().init());
  debugger;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TODO List using GetX',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
