import 'package:flutter/material.dart';
import 'package:task_manager/reusables/colors.dart';
import 'package:task_manager/reusables/text_style.dart';
import 'package:task_manager/services/theme_services.dart';

class InputField extends StatelessWidget {
  InputField({Key? key,required this.title, required this.hintText, this.controller, this.suffixIcon, required this.readOnly}) : super(key: key);

  String title,hintText;
  TextEditingController? controller;
  Widget? suffixIcon;
  bool readOnly=false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,   style: myStyle(16, FontWeight.bold, ThemeServices().isSavedDarkMode()?whiteClr:textClr),),
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1)
          ),
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
            ),

            ),
          ),
        ),
      ],
    );
  }
}
