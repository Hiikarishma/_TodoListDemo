import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/core/utils/extenstions.dart';
import 'package:todo_list/app/modules/home/controller.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0.wp,
              ),
              //const Image(image: AssetImage('assets/images/planning.png')),
              Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .6,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/planning.png'))),
              ),
              SizedBox(
                height: 10.0.wp,
              ),
              Text(
                'Add Task',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
              )
            ],
          )
        : ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...homeCtrl.doingTodos
                  .map((element) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.0.wp, vertical: 3.0.wp),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: element['done'],
                                onChanged: (value) {
                                  homeCtrl.doneTodo(element['title']);
                                },
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey[100]!),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                              child: Text(
                                element['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList(),
              homeCtrl.doingTodos.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                      child: const Divider(thickness: 2),
                    )
                  : Container()
            ],
          ));
  }
}
