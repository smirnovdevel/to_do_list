import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../env/env.dart';
import '../../config/common/app_urls.dart';
import '../../domain/models/todo.dart';
import '../../utils/core/logging.dart';
import '../../utils/exceptions/exception.dart';
import 'web_service.dart';

final Logging log = Logging('HttpService');

final InternetConnectionChecker customInstance =
    InternetConnectionChecker.createInstance(
  checkTimeout: const Duration(seconds: 1),
  checkInterval: const Duration(seconds: 1),
);

class HttpService implements IWebService {
  int? revision;
  bool isConnected = true;

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
    const String url = '${AppUrls.urlTodo}/list';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept',
          'Authorization': 'Bearer ${Env.token}',
        },
      ).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          throw const ServerException('Server timeout error');
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.debug('Update revision to: $revision');
      } else {
        log.debug('Update revision, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on SocketException {
      log.warning('Update revision: SocketException');
      throw const ServerException('no_internet');
    } on HttpException {
      log.warning('Update revision: HttpException');
      throw const ServerException('server_error');
    } on FormatException {
      log.warning('Update revision: FormatException');
      throw const ServerException('bad_response_format');
    } catch (e) {
      log.warning('Update revision: ${e.toString()}');
    }
    return revision;
  }

  /// Get ALL Todo from Server
  ///
  @override
  Future<List<Todo>> getTodos() async {
    revision = await _updateRevision();
    var url = Uri.https('beta.mrdekk.ru', 'todobackend/list');
    final List<Todo> todosList = [];
    log.debug('Get Todos from: $url ...');

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept',
          'Authorization': 'Bearer ${Env.token}',
        },
      ).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          throw const ServerException('Server timeout error');
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int i = 1;
        for (final Map<String, dynamic> todo in result['list']) {
          log.debug('Get $i todo: $todo');
          todosList.add(Todo.fromJson(todo));
          i++;
        }
        revision = result['revision'];
        log.debug(
            'Get Todos, load ${todosList.length} todos revision: $revision');
      } else {
        log.debug('Get Todos, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Get Todos: Http error! STATUS: ${e.message}');
    } on TimeoutException catch (e) {
      log.warning('Get Todos: Timeout error! STATUS: ${e.message}');
    } on SocketException catch (e) {
      log.warning('Get Todos: Socket error! STATUS: ${e.message}');
    }
    return todosList;
  }

  /// SAVE Todo to Server
  ///
  @override
  Future<Todo> saveTodo({required Todo todo}) async {
    revision = await _updateRevision();
    const String url = '${AppUrls.urlTodo}/list';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    Todo? task;
    log.debug('Save Todo, revision: $revision body: $body ...');
    try {
      final http.Response response = await http
          .post(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          'Authorization': 'Bearer ${Env.token}',
        },
        body: body,
      )
          .timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          revision = null;
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.debug('Save Todo');
        task = todo.copyWith(upload: true);
      } else {
        log.debug('Save Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Save Todo: ${e.message}');
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
      final http.Response response = await http
          .patch(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          'Authorization': 'Bearer ${Env.token}',
        },
        body: body,
      )
          .timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          revision = null;
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        status = result['status'] == 'ok';
        log.debug('Update Todos revision: $revision');
      } else {
        log.debug(
            'Update Todos response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Update Todo: ${e.message}');
    }
    return status;
  }

  /// UPDATE Todo to Server
  ///
  @override
  Future<Todo> updateTodo({required Todo todo}) async {
    revision = await _updateRevision();
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    Todo? task;
    log.debug('Update Todo id: ${todo.uuid} revision: $revision');
    try {
      final http.Response response = await http
          .put(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          'Authorization': 'Bearer ${Env.token}',
        },
        body: body,
      )
          .timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.debug('Update Todo revision: $revision');
        task = todo.copyWith(upload: true);
      } else {
        log.debug(
            'Update Todo response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Update Todo: ${e.message}');
    }
    return task ?? todo;
  }

  /// GET Todo from Server
  ///
  @override
  Future<Todo?> getTodo({required String uuid}) async {
    revision = await _updateRevision();
    Todo? todo;
    final String url = '${AppUrls.urlTodo}/list/$uuid';
    log.debug('Get Todo, revision: $revision uuid: $uuid ...');
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${Env.token}',
        },
      ).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        final todoJson = json.decode(response.body);
        todo = Todo.fromJson(todoJson);
        log.debug('Get Todo');
      } else {
        log.debug('Get Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Get Todo: ${e.message}');
    }
    return todo;
  }

  /// DELETE Todo From Server
  ///
  @override
  Future<bool> deleteTodo({required Todo todo}) async {
    revision = await _updateRevision();
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.debug('Delete Todo id: ${todo.uuid} revision: $revision  body: $body');
    try {
      final http.Response response = await http
          .delete(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          'Authorization': 'Bearer ${Env.token}',
        },
        body: body,
      )
          .timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.debug('Delete Todo id: ${todo.uuid} revision: $revision');
        return true;
      } else {
        log.debug(
            'Delete Todo response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } on HttpException catch (e) {
      log.warning('Delete Todo: ${e.message}');
    }
    return false;
  }
}
