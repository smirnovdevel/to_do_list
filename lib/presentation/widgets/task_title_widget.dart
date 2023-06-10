import 'package:flutter/material.dart';

class TaskTitleWidget extends StatelessWidget {
  const TaskTitleWidget({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
        labelText: 'Text field',
      ),
    );
  }
}
