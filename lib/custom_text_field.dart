import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged onChanged;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final bool getDate;

  CustomTextField({
    this.text = "", this.hintText = "",
    required this.controller,
    required this.onChanged,
    this.onDateTimeChanged,
    this.getDate = false
  });

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            text,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black
            )
        ),
        SizedBox(height: 12),
        Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 19.2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Color(0xffEAEFF3)
                )
            ),
            child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 125,
                      child: TextField(
                          controller: controller,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintText,
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black
                              )
                          )
                      )
                  ),
                  if (getDate)
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                children: [
                                  Container(
                                      height: MediaQuery.of(context).size.height / 2 - 37,
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                          minimumYear: DateTime.now().year - 100,
                                          maximumYear: DateTime.now().year,
                                          onDateTimeChanged: onDateTimeChanged!
                                      )
                                  ),
                                  CustomButton(
                                    text: "Принять",
                                    onTap: () => Navigator.pop(context)
                                  )
                                ]
                            )
                          )
                      ),
                      child: Icon(
                          Icons.calendar_today
                      )
                    )
                  )
                ]
            )
        )
      ]
  );
}