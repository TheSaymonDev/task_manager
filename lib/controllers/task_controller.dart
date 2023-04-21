import 'package:get/get.dart';
import 'package:task_manager/models/task_models.dart';
import 'package:task_manager/services/my_db_helper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<int> addTask({TaskModels? taskModels}) async {
    return await MyDatabase.instance.create(taskModels!);
  }

  Future<int> updateTask({TaskModels? taskModels}) async{
    return await MyDatabase.instance.update(taskModels!);
  }
}
