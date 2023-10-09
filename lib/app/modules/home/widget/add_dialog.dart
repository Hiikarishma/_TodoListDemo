import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/modules/home/controller.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();

                          homeCtrl.editCtrl.clear();
                          homeCtrl.changeTask(null);
                        },
                        icon: const Icon(Icons.close)),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            if (homeCtrl.task.value == null) {
                              EasyLoading.showError('Please Select Task Type');
                            } else {
                              var success = homeCtrl.updateTask(
                                homeCtrl.task.value!,
                                homeCtrl.editCtrl.text,
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    'Todo Item Add Success!!');
                                Get.back();
                                homeCtrl.changeTask(null);
                              } else {
                                EasyLoading.showError(
                                    'Todo Item Already Exit!!');
                              }
                              homeCtrl.editCtrl.clear();
                            }
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 14.0.sp),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'New Task',
                  style:
                      TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: homeCtrl.editCtrl,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!))),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      debugPrint("Done Value : $value");
                      return 'Please Enter your TODO items';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 5.0.wp, bottom: 2.0.wp, left: 5.0.wp, right: 5.0.wp),
                child: Text(
                  'Add to',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(
                        () => InkWell(
                          onTap: () {
                            homeCtrl.changeTask(element);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0.wp, vertical: 3.0.wp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconData(element.icon!,
                                          fontFamily: 'MaterialIcons'),
                                      color: HexColor.fromHex(element.color!),
                                    ),
                                    SizedBox(
                                      width: 4.0.wp,
                                    ),
                                    Text(
                                      element.title!,
                                      style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                homeCtrl.task.value == element
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.blue,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
