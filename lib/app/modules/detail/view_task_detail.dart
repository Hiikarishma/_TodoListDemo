import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/modules/detail/widgets/doing_list.dart';
import 'package:todo_list/app/modules/detail/widgets/done_list.dart';
import 'package:todo_list/app/modules/home/controller.dart';

class TaskDetailPage extends StatelessWidget {
  //dependency injuction
  final homeCtrl = Get.find<HomeController>();
  TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    final color = HexColor.fromHex(task.color!);
    return WillPopScope(
      onWillPop: () {
        homeCtrl.updateTodos();
        homeCtrl.editCtrl.clear();
        return Future.value(true);
      },
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        // homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0.wp),
                child: Row(
                  children: [
                    Icon(
                      IconData(task.icon!, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                    SizedBox(
                      width: 5.0.wp,
                    ),
                    Text(
                      task.title!,
                      style: TextStyle(
                          fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Obx(() {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                      left: 18.0.wp, right: 16.0.wp, top: 3.0.wp),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Expanded(
                          child: StepProgressIndicator(
                        totalSteps: totalTodos == 0 ? 1 : totalTodos,
                        currentStep: homeCtrl.doneTodos.length,
                        size: 5,
                        padding: 0,
                        selectedGradientColor: LinearGradient(
                            colors: [color.withOpacity(0.5), color],
                            end: Alignment.bottomRight,
                            begin: Alignment.topLeft),
                        unselectedGradientColor: LinearGradient(
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                            end: Alignment.bottomRight,
                            begin: Alignment.topLeft),
                      ))
                    ],
                  ),
                );
              }),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: homeCtrl.editCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(

                    
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    prefixIcon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey[400]!,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            var success =
                                homeCtrl.addTodo(homeCtrl.editCtrl.text);
                            success
                                ? EasyLoading.showSuccess(
                                    'Todo Item add Success!!')
                                : EasyLoading.showError(
                                    'Todo Item Already Exist!!');
                            homeCtrl.editCtrl.clear();
                          }
                        },
                        icon: const Icon(Icons.done)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please Enter Your TODO Items';
                    }
                    return null;
                  },
                ),
              ),
              DoingList(),
              DoneList()
            ],
          ),
        ),
      ),
    );
  }
}
