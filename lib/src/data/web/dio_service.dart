import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../config/common/app_urls.dart';
import '../../domain/models/todo.dart';
import '../../utils/error/exception.dart';
import '../../../env/apikey.env';
import 'web_service.dart';

final Logger log = Logger('DioService');

class DioService implements IWebService {
  int? revision;

  /// Get ALL Todo from Server
  ///
  @override
  Future<List<Todo>> getTodos() async {
    const String url = '${AppUrls.urlTodo}/list';
    final List<Todo> todosList = [];

    log.info('Get Todos from: $url ...');
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $tokenApiKey',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int i = 1;
        for (final Map<String, dynamic> todo in result['list']) {
          log.info('Get $i todo: $todo');
          todosList.add(Todo.fromJson(todo));
          i++;
        }
        revision = result['revision'];
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
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    log.info('Find Todo before Save, revision: $revision ...');
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          HttpHeaders.authorizationHeader: 'Bearer $tokenApiKey',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
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
    const String url = '${AppUrls.urlTodo}/list';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Add Todo, revision: $revision body: $body ...');
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          HttpHeaders.authorizationHeader: 'Bearer $tokenApiKey',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        todo = todo.copyWith(upload: true);
        revision = result['revision'];
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
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Update Todo id: ${todo.uuid} revision: $revision');
    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $tokenApiKey',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
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
    final String url = '${AppUrls.urlTodo}/list/${todo.uuid}';
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Delete Todo id: ${todo.uuid} revision: $revision  body: $body');
    try {
      final http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $tokenApiKey',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
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

  Future<Todo> getTodo({required int id}) async {
    final String url = '${AppUrls.urlTodo}/list/$id';
    log.info('getAllTodosFromServer get from: $url');
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $tokenApiKey',
      },
    );
    if (response.statusCode == 200) {
      final todoJson = json.decode(response.body);
      final Todo todo = Todo.fromJson(todoJson);
      log.info('getTodoByIDFromServer load ${todo.title} by id: $id');
      return todo;
    } else {
      log.info('getAllTodosFromServer response code: ${response.statusCode}');
      throw ServerException(response.statusCode.toString());
    }
  }
}
