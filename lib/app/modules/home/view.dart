import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/core/values/color.dart';
import 'package:todo_list/app/data/models/task.dart';
import 'package:todo_list/app/modules/home/controller.dart';
import 'package:todo_list/app/modules/home/widget/add_card.dart';
import 'package:todo_list/app/modules/home/widget/add_dialog.dart';
import 'package:todo_list/app/modules/home/widget/task_card.dart';
import 'package:todo_list/app/modules/report/report_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0.wp, vertical: 2.0.wp),
                    child: const Text('Yes'),
                  ),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: Obx(
          () => IndexedStack(index: controller.tabIndex.value, children: [
            SafeArea(
                child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    'todo List',
                    style: TextStyle(
                        fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                //obx use for change state management
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                     shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...controller.tasks
                          .map((element) => LongPressDraggable(
                              data: element,
                              onDragStarted: () =>
                                  controller.changeDeleting(true),
                              onDraggableCanceled: (_, __) =>
                                  controller.changeDeleting(false),
                              onDragEnd: (_) =>
                                  controller.changeDeleting(false),
                              feedback: Opacity(
                                opacity: 0.8,
                                child: TaskCard(task: element),
                              ),
                              child: TaskCard(task: element)))
                          .toList(),
                      // TaskCard(
                      //     task: const Task(
                      //         title: 'title',
                      //         icon: 0xe596,
                      //         color: '#FF2B60E6',
                      //         todos: [])),
                      AddCard()
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(10.0.wp),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         Get.snackbar('title', 'message',
                //             snackPosition: SnackPosition.BOTTOM);
                //       },
                //       child: const Text('SnackBar')),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(10.0.wp),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         Get.defaultDialog(
                //             title: 'Dialog Box', content: Text('hello user'));
                //       },
                //       child: const Text('Dialog Box')),
                // )
              ],
            )),
            ReportPage()
          ]),
        ),
        floatingActionButton: DragTarget<Task>(
          builder: (_, __, ___) {
            return Obx(
              () => FloatingActionButton(
                onPressed: () {
                  controller.tasks.isNotEmpty
                      ? Get.to(() => AddDialog(),
                          transition: Transition.downToUp)
                      : EasyLoading.showError('Please Create your Task Type');
                },
                backgroundColor: controller.deleting.value ? Colors.red : blue,
                child:
                    Icon(controller.deleting.value ? Icons.delete : Icons.add),
              ),
            );
          },
          onAccept: (Task task) {
            controller.deleteTask(task);
            EasyLoading.showSuccess('Delete Sucess');
          },
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.apps)),
              BottomNavigationBarItem(
                label: 'Report',
                icon: Icon(Icons.data_usage),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
