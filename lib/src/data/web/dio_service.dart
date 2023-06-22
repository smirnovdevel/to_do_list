import 'dart:convert';
import 'dart:io';

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

  Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.urlTodo,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${Env.token}',
      },
    ),
  );

  /// Get ALL Todo from Server
  ///
  @override
  Future<List<Todo>> getTodos() async {
    final List<Todo> todosList = [];

    log.info('Get Todos ...');
    try {
      Response response = await dio.get('/list');
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
    log.info('Find Todo before Save, revision: $revision ...');
    try {
      Response response = await dio.get('/list/${todo.uuid}');
      if (response.statusCode == 200) {
        revision = response.data['revision'];
        log.info(
            'Todo id: ${todo.uuid} found, need update revision: $revision ...');
        return updateTodo(todo: todo);
      } else {
        log.info(
            'Save Todo id: ${todo.uuid} not found, need insert revision: $revision ...');
        return insertTodo(todo: todo);
      }
    } catch (e) {
      log.warning('Save Todo: $e');
    }
    return todo;
  }

  /// INSERT Todo to Server
  ///
  Future<Todo> insertTodo({required Todo todo}) async {
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Add Todo, revision: $revision body: $body ...');

    try {
      Response response = await dio.post(
        '/list/${todo.uuid}',
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        todo = todo.copyWith(upload: true);
        revision = response.data['revision'];
        log.info('Add Todo');
        todo.copyWith(upload: true);
      } else {
        log.info('Save Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Save Todo: $e');
    }
    return todo;
  }

  /// UPDATE Todo to Server
  ///
  Future<Todo> updateTodo({required Todo todo}) async {
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Update Todo id: ${todo.uuid} revision: $revision');
    try {
      Response response = await dio.put(
        '/list/${todo.uuid}',
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
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
  Future<Todo> deleteTodo({required Todo todo}) async {
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Delete Todo id: ${todo.uuid} revision: $revision  body: $body');
    try {
      Response response = await dio.delete(
        '/list/${todo.uuid}',
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
          },
        ),
      );

      if (response.statusCode == 200) {
        revision = response.data['revision'];
        log.info('Delete Todo id: ${todo.uuid} revision: $revision');
      } else {
        log.info(
            'Delete Todo response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Delete Todo: $e');
    }
    return todo;
  }
}
