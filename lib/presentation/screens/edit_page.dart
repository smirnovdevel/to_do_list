import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/common/app_color.dart';
import 'package:to_do_list/models/task.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../bloc/task_bloc.dart';
import '../../routes/navigation.dart';
import '../widgets/build_items_popup_menu.dart';
import '../widgets/hint_popup_menu_widget.dart';
import '../widgets/row_delete_item_widget.dart';
import '../widgets/task_text_field_widget.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.task,
    required this.isCreate,
  });

  final TaskModel task;
  final bool isCreate;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _controller = TextEditingController();

  DateFormat dateFormat = DateFormat('dd MMMM yyyy');
  late bool _active;
  late int _priority;
  late bool _unlimited;
  late DateTime _deadline;
  late bool _isCreate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        locale: const Locale('ru'),
        context: context,
        cancelText: 'ОТМЕНА',
        confirmText: 'ГОТОВО',
        initialDate: _deadline,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColor.darkBlue,
                    primaryContainer: Colors.white,
                    secondaryContainer: Colors.white,
                    onSecondary: Colors.red,
                    onSurface: Theme.of(context).primaryColor,
                    surface: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF252528),
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
    _active = widget.task.active;
    _priority = widget.task.priority;
    _unlimited = widget.task.unlimited;
    _deadline = widget.task.deadline;
    _isCreate = widget.isCreate;
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
    final popupMenuItems = buildItemsPopupMenu(context);

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
                widget.task.active = _active;
                widget.task.priority = _priority;
                widget.task.unlimited = _unlimited;
                widget.task.deadline = _deadline;
                if (!_isCreate) {
                  context.read<TaskBloc>().add(UpdateTask(task: widget.task));
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
              RowDeleteItemWidget(isCreate: _isCreate, task: widget.task)
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
              if (!_unlimited) {
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
                _unlimited
                    ? Container()
                    : Text(
                        DateFormat('dd MMMM yyyy', 'ru')
                            .format(_deadline)
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).iconTheme.color),
                      ),
              ],
            ),
          ),
          Switch(
              value: !_unlimited,
              onChanged: (bool value) {
                _unlimited = !value;
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
        onSelected: (value) {
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
