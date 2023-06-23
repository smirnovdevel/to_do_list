import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../env/env.dart';
import '../../config/common/app_urls.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../../utils/error/exception.dart';
import 'web_service.dart';

final Logging log = Logging('DioService');

class DioService implements IWebService {
  int? revision;

  Dio dio = Dio();

  /// Get ALL Todo from Server
  ///
  @override
  Future<List<Todo>> getTodos() async {
    final List<Todo> todosList = [];
    log.info('Get Todos ...');
    try {
      Response response = await dio.get(
        '${AppUrls.urlTodo}/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Env.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        int i = 1;
        for (final Map<String, dynamic> todo in response.data['list']) {
          log.info('Get $i todo: $todo');
          todosList.add(Todo.fromJson(todo));
          i++;
        }
        revision = response.data['revision'];
        log.info(
            'Get Todos, load ${todosList.length} todos revision: $revision');
      } else {
        log.info('Get Todos, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Get Todos: $e');
    }
    return todosList;
  }

  /// SAVE Todo to Server
  ///
  @override
  Future<Todo> saveTodo({required Todo todo}) async {
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    Todo? task;
    log.info('Save Todo, revision: $revision body: $body ...');
    const String url = '${AppUrls.urlTodo}/list';
    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
            'Authorization': 'Bearer ${Env.token}',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        todo = todo.copyWith(upload: true);
        revision = response.data['revision'];
        log.info('Save Todo');
        task = todo.copyWith(upload: true);
      } else {
        log.info('Save Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Save Todo: $e');
    }
    return task ?? todo;
  }

  /// UPDATE LIST Todo to Server
  ///
  Future<bool> updateTodos({required List<Todo> todos}) async {
    bool status = false;
    List<Map<String, dynamic>> listJson =
        List.generate(todos.length, (index) => todos[index].toJson());
    final String body = jsonEncode({
      'list': listJson,
    });
    log.info('Update ${todos.length} Todos revision: $revision');
    const String url = '${AppUrls.urlTodo}/list';
    try {
      Response response = await dio.patch(
        url,
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
            'Authorization': 'Bearer ${Env.token}',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        revision = response.data['revision'];
        status = response.data['status'] == 'ok';
        log.info('Update Todos revision: $revision');
      } else {
        log.info(
            'Update Todos response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Update Todo: $e');
    }
    return status;
  }

  /// UPDATE Todo to Server
  ///
  Future<Todo> updateTodo({required Todo todo}) async {
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Update Todo id: ${todo.uuid} revision: $revision');
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    try {
      Response response = await dio.put(
        url,
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
            'Authorization': 'Bearer ${Env.token}',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        revision = response.data['revision'];
        log.info('Update Todo revision: $revision');
        return todo.copyWith(upload: true);
      } else {
        log.info(
            'Update Todo response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Update Todo: $e');
    }
    return todo;
  }

  /// DELETE Todo From Server
  ///
  @override
  Future<bool> deleteTodo({required Todo todo}) async {
    bool result = false;
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Delete Todo id: ${todo.uuid} revision: $revision  body: $body');
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    try {
      Response response = await dio.delete(
        url,
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
            'Authorization': 'Bearer ${Env.token}',
          },
          validateStatus: (status) {
            if (status == null) return false;
            if (status >= 200 && status < 300) {
              return true;
            }
            if (status == 404) {
              result = true;
            }
            return false;
          },
        ),
      );

      revision = response.data['revision'];
      log.info(
          'Delete Todo response code: ${response.statusCode} revision: $revision');
      return true;
    } catch (e) {
      log.warning('Delete Todo: $e');
      return result;
    }
  }
}
