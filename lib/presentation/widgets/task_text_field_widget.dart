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
          cursorColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Что надо сделать...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                height: 18 / 16,
              )),
        ),
      ),
    );
  }
}
