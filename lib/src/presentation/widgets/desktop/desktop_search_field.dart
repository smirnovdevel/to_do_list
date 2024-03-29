import 'package:flutter/material.dart';

class DesktopSearchField extends StatelessWidget {
  const DesktopSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
