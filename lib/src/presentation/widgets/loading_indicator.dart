import 'package:flutter/material.dart';

Widget loadingIndicator() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: CircularProgressIndicator(
        color: Colors.red,
        strokeWidth: 2.0,
      ),
    ),
  );
}
