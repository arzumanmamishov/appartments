import 'package:flutter/material.dart';

InputDecoration decorationForTextFormField(String textForForm, {Widget? icon}) {
  return InputDecoration(
      isDense: true,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: icon,
      ),
      focusedBorder: outlineMainInputFocusedBorder,
      enabledBorder: outlineMainInputFocusedBorder,
      contentPadding:
          // ignore: prefer_const_constructors
          EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
      hintStyle: const TextStyle(
          color: Color.fromARGB(255, 112, 112, 112),
          fontSize: 14,
          fontWeight: FontWeight.w600),
      border: InputBorder.none,
      hintText: textForForm);
}

final outlineMainInputFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide:
      const BorderSide(color: Color.fromARGB(255, 171, 107, 255), width: 1.5),
);
