import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/core/values/color.dart';
import 'package:todo_list/app/modules/home/controller.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          var createdTask = homeCtrl.getTotalTask();
          var completedTask = homeCtrl.getTotalDoneTask();
          var liveTasks = createdTask - completedTask;
          var percent = (completedTask / createdTask * 100).toStringAsFixed(0);
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(4.0.wp),
                child: Text(
                  'My Report',
                  style:
                      TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                child: Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(color: Colors.grey, fontSize: 14.0.sp),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.wp, vertical: 3.0.wp),
                child: const Divider(
                  thickness: 2,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.wp, vertical: 3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatus(Colors.green, liveTasks, 'Live'),
                    _buildStatus(Colors.orange, completedTask, 'Completed'),
                    _buildStatus(Colors.blue, createdTask, 'Created'),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0.wp,
              ),
              UnconstrainedBox(
                child: SizedBox(
                  height: 70.0.wp,
                  width: 70.0.wp,
                  child: CircularStepProgressIndicator(
                    totalSteps: createdTask == 0 ? 1 : createdTask,
                    currentStep: completedTask,
                    stepSize: 20,
                    selectedColor: green,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 22,
                    roundedCap: (_, __) => true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${createdTask == 0 ? 0 : percent} %',
                          style: TextStyle(
                              fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.0.wp,
                        ),
                        Text(
                          'Efficiency',
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3.0.wp,
          width: 3.0.wp,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 0.5.wp, color: color)),
        ),
        SizedBox(
          width: 3.0.wp,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
            ),
            SizedBox(
              height: 2.0.wp,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
            )
          ],
        )
      ],
    );
  }
}
