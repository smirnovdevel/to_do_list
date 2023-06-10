import 'package:flutter/material.dart';

import '../../models/globals.dart' as globals;

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
    PopupMenuItem<int>(
      value: 2,
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        width: (globals.widthScreen - 64) / 2,
        child: const Text(
          '!! Высокий',
          style:
              TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
  return list;
}
