import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/reusables/colors.dart';

customToast(String msg){
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: pinkClr,
      textColor: whiteClr,
      fontSize: 16.0
  );
}