import 'package:flutter/material.dart';

class TaskTextFieldWidget extends StatelessWidget {
  const TaskTextFieldWidget({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 3,
          showCursor: true,
          cursorColor: Colors.black,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16.0),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Что надо сделать...',
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0)),
        ),
      ),
    );
  }
}
