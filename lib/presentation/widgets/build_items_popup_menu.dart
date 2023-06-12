import 'package:flutter/material.dart';

List<PopupMenuEntry<int>> buildItemsPopupMenu() {
  List<PopupMenuEntry<int>> list = [];
  list.add(const PopupMenuItem<int>(
      value: 0,
      padding: EdgeInsets.only(left: 16),
      child: Text(
        'Нет',
        style: TextStyle(color: Colors.black),
      )));
  list.add(const PopupMenuItem<int>(
      value: 1,
      padding: EdgeInsets.only(left: 16),
      child: Text(
        'Низкий',
        style: TextStyle(color: Colors.black),
      )));
  list.add(
    const PopupMenuItem<int>(
      value: 2,
      padding: EdgeInsets.only(left: 16),
      child: SizedBox(
        width: 120,
        child: Text(
          '!! Высокий',
          style:
              TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
  return list;
}
