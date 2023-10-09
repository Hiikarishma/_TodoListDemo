import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/core/values/color.dart';
import 'package:todo_list/app/modules/home/controller.dart';
import 'package:todo_list/app/widgets/icons.dart';

import '../../../data/models/task.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddCard extends StatelessWidget {
  //dependency injuction
  final homeCtrl = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);

  // @override
  // void initState() {
  //  // super.initState();
  //   getValue();
  // }

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'Task Type',
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        controller: homeCtrl.editCtrl,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Title'),
                        validator: (Value) {
                          if (Value == null || Value.trim().isEmpty) {
                            return 'Please Enter Your Task Title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                      child: Wrap(
                        spacing: 2.0.wp,
                        children: icons
                            .map((e) => Obx(() {
                                  final index = icons.indexOf(e);
                                  return ChoiceChip(
                                    selectedColor: Colors.grey[200],
                                    pressElevation: 0,
                                    backgroundColor: Colors.white,
                                    label: e,
                                    selected: homeCtrl.clipIndex.value == index,
                                    onSelected: (bool selected) {
                                      homeCtrl.clipIndex.value =
                                          selected ? index : 0;
                                    },
                                  );
                                }))
                            .toList(),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // Get.snackbar('title', 'message',
                          //     snackPosition: SnackPosition.BOTTOM);
                          if (homeCtrl.formKey.currentState!.validate()) {
                            int icon =
                                icons[homeCtrl.clipIndex.value].icon!.codePoint;

                            String color =
                                icons[homeCtrl.clipIndex.value].color!.toHex();

                            var task = Task(
                                title: homeCtrl.editCtrl.text,
                                icon: icon,
                                color: color,
                                todos: const []);
                            Get.back();
                            homeCtrl.addTask(task)
                                ? EasyLoading.showSuccess('Create Success')
                                : EasyLoading.showError('Duplicate Task');

                            var preference =
                                await SharedPreferences.getInstance();
                            preference.setString(
                                "TODOS TASK", jsonEncode(task));
                          }

                          //save task in shared-preference
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            minimumSize: const Size(150, 40)),
                        child: const Text('Confirm'))
                  ],
                ),
              ));
          homeCtrl.editCtrl.clear();
          homeCtrl.changeClipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
              child: Icon(
            Icons.add,
            size: 10.0.wp,
            color: Colors.grey,
          )),
        ),
      ),
    );
  }
}
