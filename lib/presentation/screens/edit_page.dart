import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:intl/intl.dart';
import '../widgets/build_items_popup_menu.dart';
import '../widgets/row_delete_item_widget.dart';
import '../widgets/task_title_widget.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;
  final bool newTask;
  const EditTaskPage(this.task, this.newTask, {super.key});

  @override
  EditTaskPageState createState() => EditTaskPageState();
}

class EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> popupMenuHints = ['Нет', 'Низкий', 'Высокий'];
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru');
  late bool _active;
  late int _priority;
  late bool _unlimited;
  late DateTime _deadline;
  late bool _isNewTask;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _deadline,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != _deadline) {
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  @override
  void initState() {
    _controller.text = widget.task.title;
    _active = widget.task.active;
    _priority = widget.task.priority;
    _unlimited = widget.task.unlimited;
    _deadline = widget.task.deadline;
    _isNewTask = widget.newTask;

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
                widget.task.active = _active;
                widget.task.priority = _priority;
                widget.task.unlimited = _unlimited;
                widget.task.deadline = _deadline;
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
        child: SingleChildScrollView(
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
              const Divider(
                height: 0.2,
                color: Colors.grey,
              ),
              RowDeleteItemWidget(isNewTask: _isNewTask, widget: widget)
            ],
          ),
        ),
      ),
    );
  }

  Padding rowDeadLineWithSwith() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (!_unlimited) {
                _selectDate(context);
              }
            },
            child: Column(
              children: [
                const Text(
                  'Сделать до',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                ),
                _unlimited
                    ? Container()
                    : Text(
                        dateFormat.format(_deadline),
                        style: const TextStyle(color: Colors.blue),
                      ),
              ],
            ),
          ),
          Switch(
              value: !_unlimited,
              activeColor: const Color(0xFF007AFF),
              activeTrackColor: const Color(0x44007AFF),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D1D6),
              trackOutlineColor:
                  const MaterialStatePropertyAll<Color>(Color(0xFFF7F6F2)),
              onChanged: (bool value) {
                _unlimited = !value;
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
          _priority = value;
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
              popupMenuHints[_priority],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        itemBuilder: (BuildContext context) => popupMenuItems,
      ),
    );
  }
}
