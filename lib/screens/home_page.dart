import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task_models.dart';
import 'package:task_manager/reusables/colors.dart';
import 'package:task_manager/reusables/customToast.dart';
import 'package:task_manager/reusables/text_style.dart';
import 'package:task_manager/screens/add_task_page.dart';
import 'package:task_manager/screens/update_task_page.dart';
import 'package:task_manager/services/my_db_helper.dart';
import 'package:task_manager/services/notification_services.dart';
import 'package:task_manager/services/theme_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  List<TaskModels> tasks = [];

  @override
  void initState() {
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    MyDatabase.instance.getTasksByDate(selectedDate).then((value) {
      setState(() {
        tasks = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(DateTime.now()),
                      style: myStyle(
                          20,
                          FontWeight.bold,
                          ThemeServices().isSavedDarkMode()
                              ? whiteClr
                              : textClr),
                    ),
                    Text(
                      'Today',
                      style: myStyle(
                          25,
                          FontWeight.bold,
                          ThemeServices().isSavedDarkMode()
                              ? whiteClr
                              : textClr),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(AddTaskPage());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: bluishClr),
                    child: Text(
                      '+ Add Task',
                      style: myStyle(14, FontWeight.normal, whiteClr),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: bluishClr,
                selectedTextColor: Colors.white,
                dateTextStyle: myStyle(20, FontWeight.bold, Colors.grey),
                monthTextStyle: myStyle(14, FontWeight.bold, Colors.grey),
                dayTextStyle: myStyle(16, FontWeight.bold, Colors.grey),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = DateFormat('dd/MM/yyyy').format(date);
                    print('selected date=$selectedDate');
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: MyDatabase.instance.getTasksByDate(selectedDate),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskModels>?> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return snapshot.data!.isEmpty
                      ? Center(child: Text('No data'))
                      : ListView(
                          children: snapshot.data!.map((e) {
                            return GestureDetector(
                              onTap: () {
                                _openShowModalBottomSheet(
                                    e.id!, e.title, e.note, e.date);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: e.color == 0
                                      ? bluishClr
                                      : e.color == 1
                                          ? pinkClr
                                          : yellowClr,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${e.title}',
                                      style: myStyle(
                                          16, FontWeight.bold, whiteClr),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          color: whiteClr,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${e.startTime} - ${e.endTime}',
                                          style: myStyle(
                                              15, FontWeight.normal, whiteClr),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${e.note}',
                                      style: myStyle(
                                          15, FontWeight.normal, whiteClr),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            ThemeServices().changeTheme();
            notifyHelper.displayNotification(
                title: 'Theme Changed',
                body: Get.isDarkMode
                    ? 'Activated LightMode'
                    : 'Activated DarkMode');
          });
        },
        icon: Icon(
          ThemeServices().isSavedDarkMode()
              ? Icons.light_mode
              : Icons.dark_mode,
          color:
              ThemeServices().isSavedDarkMode() ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage('images/saymon.jpg'),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  _openShowModalBottomSheet(int id, String? title, String? note, String? date) {
    return Get.bottomSheet(Container(
      padding: EdgeInsets.all(15),
      color: whiteClr,
      height: 220,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                  UpdateTaskPage(
                    id: id,
                    title: title,
                    note: note,
                    date: date,
                  ),
                  transition: Transition.zoom,
                  duration: Duration(seconds: 1),
                  fullscreenDialog: true);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: bluishClr),
              child: Text(
                'Edit Task',
                style: myStyle(18, FontWeight.w500, whiteClr),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                MyDatabase.instance.delete(id);
                customToast('Task Deleted Successfully');
                Get.close(1);
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: pinkClr),
              child: Text(
                'Delete Task',
                style: myStyle(18, FontWeight.w500, whiteClr),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.close(1);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: yellowClr, width: 1)),
              child: Text(
                'Close',
                style: myStyle(18, FontWeight.w500, yellowClr),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
