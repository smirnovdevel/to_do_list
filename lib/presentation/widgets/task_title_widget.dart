import 'package:flutter/material.dart';

class TaskTextFieldWidget extends StatelessWidget {
  const TaskTextFieldWidget({
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
