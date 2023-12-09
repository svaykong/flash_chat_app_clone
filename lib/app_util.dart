import 'package:flutter/material.dart';

const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.lightBlueAccent;
const Color thirdColor = Colors.white;

const kTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: secondaryColor,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: secondaryColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  ),
);
