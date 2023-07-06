import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_main.dart' as test_app;

Future<void> restoreFlutterError(Future<void> Function() call) async {
  try {
    await call();
  } catch (e) {
    final overriddenOnError = FlutterError.onError!;
    FlutterError.onError = (FlutterErrorDetails details) {
      overriddenOnError(details);
    };
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Creating todo by pressing floating button',
    (WidgetTester tester) async {
      await restoreFlutterError(() async {
        test_app.main();

        // Расставлю задержки для крастоты
        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Ищем Floating button
        final Finder fb = find.byTooltip('Add_todo');

        await tester.tap(fb);
        await tester.pumpAndSettle();

        // Расставлю задержки для крастоты
        await Future.delayed(const Duration(seconds: 2));

        // Заполняем содержимое тутушки
        final Finder field = find.byType(TextField).first;
        await tester.enterText(field, 'Create todo by test');
        await tester.pumpAndSettle();

        // Расставлю задержки для крастоты
        await Future.delayed(const Duration(seconds: 2));

        // Сохраняем
        final Finder save = find.byKey(const Key('TextButtonSave'));
        await tester.tap(save);
        await tester.pumpAndSettle();

        // Скролим, возможно она вне зоны видимости
        await tester.scrollUntilVisible(
          find.text('Create todo by test'),
          200,
          duration: const Duration(
            milliseconds: 100,
          ),
        );
        await tester.pumpAndSettle();

        // Расставлю задержки для крастоты
        await Future.delayed(const Duration(seconds: 2));

        // Проверяем
        expect(find.text('Create todo by test'), findsWidgets);

        final title = find.text('Create todo by test');
        await tester.tap(title);
        await tester.pumpAndSettle();

        // Изменяем содержимое тутушки
        final Finder update = find.byType(TextField).first;
        await tester.enterText(update, 'Update todo by test');
        await tester.pumpAndSettle();

        // Скролим, возможно она вне зоны видимости
        await tester.scrollUntilVisible(
          find.text('Update todo by test'),
          200,
          duration: const Duration(
            milliseconds: 100,
          ),
        );
        await tester.pumpAndSettle();

        // Проверяем
        expect(find.text('Update todo by test'), findsWidgets);
      });
    },
  );
}
