import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../config/common/app_color.dart';
import '../../config/routes/navigation.dart';
import '../../domain/models/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../widgets/build_items_popup_menu.dart';
import '../widgets/hint_popup_menu_widget.dart';
import '../widgets/row_delete_item_widget.dart';
import '../widgets/task_text_field_widget.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _controller = TextEditingController();

  DateFormat dateFormat = DateFormat('dd MMMM yyyy');
  late bool _done;
  late int _priority;
  late DateTime? _deadline;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        locale: const Locale('ru'),
        context: context,
        cancelText: 'ОТМЕНА',
        confirmText: 'ГОТОВО',
        initialDate: _deadline ?? DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColor.darkBlue,
                    primaryContainer: Colors.white,
                    secondaryContainer: Colors.white,
                    onSecondary: Colors.red,
                    surface: Theme.of(context).colorScheme.primary,
                    onSurface: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF252528)
                        : Colors.white,
                    onSurfaceVariant:
                        Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFF252528)
                            : Colors.white,
                    secondary: Colors.blue,
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).iconTheme.color,
                  // primary: Colors.green, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (pickedDate != null && pickedDate != _deadline) {
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  @override
  void initState() {
    _controller.text = widget.task.title;
    _done = widget.task.done;
    _priority = widget.task.priority;
    _deadline = widget.task.deadline;
    initializeDateFormatting();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGoBack(TaskModel? task) {
    NavigationManager.instance.pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry<int>> popupMenuItems =
        buildItemsPopupMenu(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.shadow,
        // иконка закрыть без сохранения
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _onGoBack(null);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        // закрыть и сохранить
        actions: [
          TextButton(
              onPressed: () {
                widget.task.title = _controller.text;
                widget.task.done = _done;
                widget.task.priority = _priority;
                widget.task.deadline = _deadline;
                widget.task.changed = DateTime.now();
                if (widget.task.uuid != null) {
                  context.read<TaskBloc>().add(SaveTask(task: widget.task));
                }
                _onGoBack(widget.task);
              },
              child: Text(
                'СОХРАНИТЬ',
                style: Theme.of(context).textTheme.titleMedium,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskTextFieldWidget(controller: _controller),
              popupMenuWidget(popupMenuItems),
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Divider(
                  height: 0.2,
                ),
              ),
              rowDeadLineWithSwith(),
              const Divider(
                height: 0.2,
              ),
              RowDeleteItemWidget(task: widget.task)
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Строка выбора времени задачи
  ///
  Padding rowDeadLineWithSwith() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (_deadline != null) {
                _selectDate(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Сделать до',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_deadline == null)
                  Container()
                else
                  Text(
                    DateFormat('dd MMMM yyyy', 'ru')
                        .format(_deadline ?? DateTime.now()),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).iconTheme.color),
                  ),
              ],
            ),
          ),
          Switch(
              value: _deadline != null,
              onChanged: (bool value) {
                if (value) {
                  _deadline = DateTime.now();
                } else {
                  _deadline = null;
                }
                setState(() {});
              }),
        ],
      ),
    );
  }

  ///
  /// Строка выбора важности задачи
  ///
  Padding popupMenuWidget(List<PopupMenuEntry<int>> popupMenuItems) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: PopupMenuButton<int>(
        initialValue: _priority,
        position: PopupMenuPosition.over,
        color: Theme.of(context).popupMenuTheme.color,
        onSelected: (int value) {
          setState(() {
            _priority = value;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Важность',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            HintPopupMenuWidget(value: _priority),
          ],
        ),
        itemBuilder: (BuildContext context) => popupMenuItems,
      ),
    );
  }
}
