import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/models/task_models.dart';
import 'package:task_manager/reusables/colors.dart';
import 'package:task_manager/reusables/input_field.dart';
import 'package:task_manager/reusables/text_style.dart';
import 'package:task_manager/screens/home_page.dart';
import 'package:task_manager/services/theme_services.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  TextEditingController? _titleController = TextEditingController();
  TextEditingController? _noteController = TextEditingController();
  TextEditingController? _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '09:30 PM';
  int _selectedRemind = 5;
  List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _seletedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back,
                color: ThemeServices().isSavedDarkMode() ? whiteClr : textClr)),
        title: Text(
          'Add Task',
          style: myStyle(20, FontWeight.bold,
              ThemeServices().isSavedDarkMode() ? whiteClr : textClr),
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
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                title: 'Title',
                controller: _titleController,
                readOnly: false,
                hintText: 'Enter Title Here',
              ),
              SizedBox(
                height: 12,
              ),
              InputField(
                title: 'Note',
                controller: _noteController,
                readOnly: false,
                hintText: 'Enter Note Here',
              ),
              SizedBox(
                height: 12,
              ),
              InputField(
                title: 'Date',
                readOnly: true,
                controller: _dateController,
                hintText: DateFormat('dd/MM/yyyy').format(_selectedDate),
                suffixIcon: IconButton(
                    onPressed: () {
                      _getDateFromUser(context);
                    },
                    icon: Icon(Icons.calendar_month)),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        title: 'Start Time',
                        readOnly: true,
                        hintText: _startTime,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
                            },
                            icon: Icon(Icons.watch_later_outlined)),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        title: 'End Time',
                        readOnly: true,
                        hintText: _endTime,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
                            },
                            icon: Icon(Icons.watch_later_outlined)),
                      ),
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              InputField(
                title: 'Remind',
                readOnly: true,
                hintText: '$_selectedRemind minutes early',
                suffixIcon: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 30,
                  elevation: 4,
                  underline: SizedBox(
                    height: 0,
                  ),
                  items: _remindList
                      .map<DropdownMenuItem<String>>((int value) =>
                          DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(value.toString())))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InputField(
                title: 'Repeat',
                readOnly: true,
                hintText: '$_selectedRepeat',
                suffixIcon: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 30,
                  elevation: 4,
                  underline: SizedBox(
                    height: 0,
                  ),
                  items: _repeatList
                      .map<DropdownMenuItem<String>>((String value) =>
                          DropdownMenuItem<String>(
                              value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color',
                        style: myStyle(
                            16,
                            FontWeight.bold,
                            ThemeServices().isSavedDarkMode()
                                ? whiteClr
                                : textClr),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Wrap(
                          children: List<Widget>.generate(
                              3,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _seletedColor = index;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: index == 0
                                            ? bluishClr
                                            : index == 1
                                                ? pinkClr
                                                : yellowClr,
                                        child: _seletedColor == index
                                            ? Icon(
                                                Icons.done,
                                                size: 16,
                                                color: whiteClr,
                                              )
                                            : null,
                                      ),
                                    ),
                                  )))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _validateData();
                      print('clicked');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: bluishClr),
                      child: Text(
                        'Create Task',
                        style: myStyle(14, FontWeight.normal, whiteClr),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController!.text.isNotEmpty &&
        _noteController!.text.isNotEmpty &&
        _dateController!.text.isNotEmpty) {
      _addTaskToDb();
      Get.offAll(HomePage());
    } else if (_titleController!.text.isEmpty ||
        _noteController!.text.isEmpty ||
        _dateController!.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: whiteClr,
        colorText: Colors.pink,
        icon: Icon(Icons.warning_amber_outlined),
      );
    }
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));

    if (_pickerDate != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(_pickerDate);
        print("Dte $formattedDate");
        _dateController!.text = formattedDate;
      });
    } else {
      print('it is null or something is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print('time canceled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])));
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        taskModels: TaskModels(
      title: _titleController!.text,
      note: _noteController!.text,
      // date: DateFormat.yMd().format(_selectedDate),
      date: _dateController!.text,
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _seletedColor,
      isCompleted: 0,
    ));
    print('My id is $value');
  }
}
