import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:intl/intl.dart';
import '../widgets/build_items_popup_menu.dart';
import '../widgets/task_title_widget.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;
  const EditTaskPage(this.task, {super.key});

  @override
  EditTaskPageState createState() => EditTaskPageState();
}

class EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> popupMenuHints = ['Нет', 'Низкий', 'Высокий'];
  late DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popupMenuItems = buildItemsPopupMenu();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, null)),
        actions: [
          TextButton(
              onPressed: () {
                widget.task.title = _controller.text;
                Navigator.pop(context, widget.task);
              },
              child: const Text(
                'СОХРАНИТЬ',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskTitleWidget(controller: _controller),
            popupMenuWidget(popupMenuItems),
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Divider(
                height: 0.2,
                color: Colors.grey,
              ),
            ),
            rowDeadLineWithSwith(),
          ],
        ),
      ),
    );
  }

  Padding rowDeadLineWithSwith() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                'Сделать до',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
              ),
              widget.task.unlimited
                  ? Container()
                  : Text(
                      dateFormat.format(widget.task.deadline),
                      style: const TextStyle(color: Colors.blue),
                    ),
            ],
          ),
          Switch(
              value: !widget.task.unlimited,
              activeColor: const Color(0xFF007AFF),
              activeTrackColor: const Color(0x44007AFF),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D1D6),
              trackOutlineColor:
                  const MaterialStatePropertyAll<Color>(Color(0xFFF7F6F2)),
              onChanged: (bool value) {
                widget.task.unlimited = !value;
                setState(() {});
              }),
        ],
      ),
    );
  }

  Padding popupMenuWidget(List<PopupMenuEntry<int>> popupMenuItems) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: PopupMenuButton<int>(
        // padding: EdgeInsets.only(right: width),
        initialValue: null,
        position: PopupMenuPosition.over,
        onSelected: (value) {
          widget.task.priority = value;
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Важность',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
            ),
            Text(
              popupMenuHints[widget.task.priority],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        itemBuilder: (BuildContext context) => popupMenuItems,
      ),
    );
  }
}
