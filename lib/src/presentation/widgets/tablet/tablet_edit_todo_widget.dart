import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../config/common/app_color.dart';
import '../../../domain/models/todo.dart';
import '../../../utils/core/logging.dart';
import '../../../utils/core/scale_size.dart';
import '../../core/localization/app_localization.dart';
import '../../provider/current_todo_provider.dart';
import '../../provider/todos_manager.dart';
import 'tablet_items_popup_menu.dart';
import 'tablet_popup_menu_widget.dart';
import 'tablet_row_delete_widget.dart';
import '../common_widgets/todo_text_field_widget.dart';
import 'tablet_header_edit_widget.dart';
import 'tablet_save_button_widget.dart';

final Logging log = Logging('TabletEditTodoWidget');

class TabletEditTodoWidget extends ConsumerStatefulWidget {
  const TabletEditTodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  ConsumerState<TabletEditTodoWidget> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<TabletEditTodoWidget> {
  final TextEditingController _controller = TextEditingController();

  Priority _importance = Priority.basic;
  String? _uuid;
  int? _deadline;
  int? _created;
  int? _changed;
  bool _upload = false;
  bool _done = false;

  void initTodo(Todo todo) {
    _uuid = todo.uuid;
    _controller.text = todo.title;
    _importance = todo.importance;
    _deadline = todo.deadline;
    _upload = todo.upload;
    _done = todo.done;
    _created = todo.created;
    _changed = todo.changed;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        locale: AppLocalization.of(context).locale,
        context: context,
        cancelText: AppLocalization.of(context).get('cancel'),
        confirmText: AppLocalization.of(context).get('done'),
        initialDate: _deadline == null
            ? DateTime.now().toLocal()
            : DateTime.fromMillisecondsSinceEpoch(_deadline!),
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

    if (pickedDate != null) {
      setState(() {
        _deadline = pickedDate.millisecondsSinceEpoch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(choiseTodoProvider);
    initTodo(widget.todo);
    final List<PopupMenuEntry<Priority>> tabletPopupMenuItems =
        tabletItemsPopupMenu(context);

    // ignore: prefer_const_constructors
    var uuid = Uuid();
    log.debug('Edit todo ${widget.todo.uuid}');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0, right: 48.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              shadowColor: Theme.of(context).colorScheme.shadow,
              expandedHeight: 20.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: const TabletHeaderEditWidget(),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TodoTextFieldWidget(controller: _controller),
                      tabletPopupMenuWidget(tabletPopupMenuItems),
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
                      const TabletRowDeleteWidget(),
                      const SizedBox(
                        height: 32.0,
                      ),
                      InkWell(
                        key: const Key('TextButtonSave'),
                        onTap: () {
                          final todo = Todo(
                              uuid: _uuid ?? uuid.v1(),
                              title: _controller.text,
                              importance: _importance,
                              deadline: _deadline,
                              created: _created!,
                              changed: DateTime.now()
                                  .toLocal()
                                  .millisecondsSinceEpoch,
                              upload: _upload,
                              done: _done,
                              deviceId: null);
                          if (_changed == null) {
                            ref.watch(todosManagerProvider).addTodo(todo: todo);
                          } else {
                            ref
                                .watch(todosManagerProvider)
                                .updateTodo(todo: todo);
                          }
                          ref.watch(editTodoProvider.notifier).state = false;
                          ref.watch(choiseTodoProvider.notifier).state = todo;
                        },
                        child: const TabletSaveButtonWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Строка выбора времени задачи
  ///
  Padding rowDeadLineWithSwith() {
    final locale = AppLocalization.of(context).locale.languageCode;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print('Chanhe');
              if (_deadline != null) {
                _selectDate(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context).get('deadline'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                if (_deadline == null)
                  Container()
                else
                  Text(
                    DateFormat('dd MMMM yyyy', locale).format(_deadline == null
                        ? DateTime.now().toLocal()
                        : DateTime.fromMillisecondsSinceEpoch(_deadline!)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).iconTheme.color),
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
              ],
            ),
          ),
          Switch(
              value: _deadline != null,
              onChanged: (bool value) {
                log.debug('Change deadline to $value deadline: $_deadline');
                if (value) {
                  setState(() {
                    _deadline = DateTime.now().toLocal().millisecondsSinceEpoch;
                  });
                } else {
                  setState(() {
                    _deadline = null;
                  });
                }
              }),
        ],
      ),
    );
  }

  ///
  /// Строка выбора важности задачи
  ///
  Padding tabletPopupMenuWidget(
      List<PopupMenuEntry<Priority>> tabletPopupMenuItems) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: PopupMenuButton<Priority>(
        initialValue: _importance,
        position: PopupMenuPosition.over,
        color: Theme.of(context).popupMenuTheme.color,
        onSelected: (Priority value) {
          setState(() {
            _importance = value;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalization.of(context).get('importance'),
              style: Theme.of(context).textTheme.bodyMedium,
              textScaleFactor: ScaleSize.textScaleFactor(context),
            ),
            TabletPopupMenuWidget(value: _importance),
          ],
        ),
        itemBuilder: (BuildContext context) => tabletPopupMenuItems,
      ),
    );
  }
}
