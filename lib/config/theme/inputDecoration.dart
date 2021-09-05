import 'package:flutter/material.dart';

final inputDecoration = (
  BuildContext context, [
  String? hintText,
]) =>
    InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
          width: 3,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hintText: hintText,
    );
