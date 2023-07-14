import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../env/env.dart';
import '../../config/common/app_urls.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../../utils/exceptions/exception.dart';
import 'web_service.dart';

final Logging log = Logging('DioService');

final InternetConnectionChecker customInstance =
    InternetConnectionChecker.createInstance(
  checkTimeout: const Duration(seconds: 1),
  checkInterval: const Duration(seconds: 1),
);

class DioService implements IWebService {
  int? revision;
  bool isConnected = true;

  Dio dio = Dio();

  /// Check internet connection
  ///
  Future<bool> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    return await internetConnectionChecker.hasConnection;
  }

  /// UPDATE Revision Todos
  ///
  Future<int?> _updateRevision() async {
    if (!kIsWeb) {
      isConnected = await execute(customInstance);
      if (!isConnected) {
        throw const ServerException('no_internet');
      }
    }
    log.debug('Update revision from: ${revision ?? 'null'} ...');
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
        revision = response.data['revision'];
        log.debug('Update revision to: $revision');
      } else {
        log.debug('Update revision, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on DioException catch (e) {
      log.warning('Get Todos: ${e.message}');
    }
    return revision;
  }

  /// Get ALL Todo from Server
  ///
  @override
  Future<List<Todo>> getTodos() async {
    revision = await _updateRevision();
    final List<Todo> todosList = [];
    log.debug('Get Todos ...');
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
          log.debug('Get $i todo: $todo');
          todosList.add(Todo.fromJson(todo));
          i++;
        }
        revision = response.data['revision'];
        log.debug(
            'Get Todos, load ${todosList.length} todos revision: $revision');
      } else {
        log.debug('Get Todos, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log.warning('Get Todos: Dio error! STATUS: ${e.response?.statusCode}');
      } else {
        log.warning(e.message ?? '');
      }
    }
    return todosList;
  }

  /// SAVE Todo to Server
  ///
  @override
  Future<Todo> saveTodo({required Todo todo}) async {
    revision = await _updateRevision();
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    Todo? task;
    log.debug('Save Todo, revision: $revision body: $body ...');
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
        revision = response.data['revision'];
        log.debug('Save Todo');
        task = todo.copyWith(upload: true);
      } else {
        log.debug('Save Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Save Todo: $e');
    }
    return task ?? todo;
  }

  /// UPDATE LIST Todo to Server
  ///
  @override
  Future<bool> updateTodos({required List<Todo> todos}) async {
    revision = await _updateRevision();
    bool status = false;
    List<Map<String, dynamic>> listJson =
        List.generate(todos.length, (index) => todos[index].toJson());
    final String body = jsonEncode({
      'list': listJson,
    });
    log.debug('Update ${todos.length} Todos revision: $revision');
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
        log.debug('Update Todos revision: $revision');
      } else {
        log.debug(
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
  @override
  Future<Todo> updateTodo({required Todo todo}) async {
    revision = await _updateRevision();
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    Todo? task;
    log.debug('Update Todo id: ${todo.uuid} revision: $revision');
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
        log.debug('Update Todo revision: $revision');
        task = todo.copyWith(upload: true);
      } else {
        log.debug(
            'Update Todo response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Update Todo: $e');
    }
    return task ?? todo;
  }

  /// GET Todo from Server
  ///
  @override
  Future<Todo?> getTodo({required String uuid}) async {
    revision = await _updateRevision();
    Todo? todo;
    log.debug('Get Todo, revision: $revision uuid: $uuid ...');
    final String url = '${AppUrls.urlTodo}/list/$uuid';
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'X-Last-Known-Revision': revision.toString(),
            'Authorization': 'Bearer ${Env.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        revision = response.data['revision'];
        todo = Todo.fromJson(response.data['element']);
        log.debug('Get Todo');
      } else {
        log.debug('Get Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Get Todo: $e');
    }
    return todo;
  }

  /// DELETE Todo From Server
  ///
  @override
  Future<bool> deleteTodo({required Todo todo}) async {
    revision = await _updateRevision();
    bool result = false;
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.debug('Delete Todo id: ${todo.uuid} revision: $revision  body: $body');
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
      log.debug(
          'Delete Todo response code: ${response.statusCode} revision: $revision');
      return true;
    } catch (e) {
      log.warning('Delete Todo: $e');
      return result;
    }
  }
}
