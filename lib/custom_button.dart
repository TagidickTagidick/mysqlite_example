import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final bool canTap;

  CustomButton({
    required this.onTap,
    this.text = "",
    this.canTap = true
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Opacity(
          opacity: canTap ? 1 : 0.5,
          child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                  child: Text(
                      text,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white
                      )
                  )
              )
          )
      )
  );
}