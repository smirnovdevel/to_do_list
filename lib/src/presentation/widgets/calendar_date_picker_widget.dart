import 'package:flutter/material.dart';

/// Этот виджет красивее календаря из figma
/// возможно позже изменю
///
Widget calendarDatePickerWidget() {
  return Center(
      child: Container(
          // margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60),
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orangeAccent, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 1),
            onDateChanged: (DateTime value) {},
          )));
}
