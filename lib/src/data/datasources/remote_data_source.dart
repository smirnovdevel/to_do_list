import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../config/common/app_urls.dart';
import '../../domain/models/todo.dart';
import '../../utils/error/exception.dart';
import 'data_source.dart';

final Logger log = Logger('RemoteDataSource');

class ITodoRemoteDataSource implements TodoDataSource {
  ITodoRemoteDataSource({required this.client});
  final http.Client client;
  int? revision;

  final String token = 'antievolutional';

  /// Get ALL Task from Server
  ///
  @override
  Future<List<Todo>> getTasks() async {
    const String url = '${AppUrls.urlTask}/list';
    final List<Todo> tasksList = [];
    // TODO
    // final token = getToken();

    log.info('Get Tasks from: $url ...');
    try {
      final http.Response response = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int i = 1;
        for (final Map<String, dynamic> task in result['list']) {
          log.info('Get $i task: $task');
          tasksList.add(Todo.fromJson(task));
          i++;
        }
        revision = result['revision'];
        log.info(
            'Get Tasks, load ${tasksList.length} tasks revision: $revision');
      } else {
        log.info('Get Tasks, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Get Tasks: $e');
    }
    return tasksList;
  }

  /// SAVE Task to Server
  ///
  @override
  Future<Todo> saveTask({required Todo todo}) async {
    final String url = '${AppUrls.urlTask}/list/${todo.uuid}';
    // TODO
    // final token = getToken();
    log.info('Find Task before Save, revision: $revision ...');
    try {
      final http.Response response = await client.get(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.info(
            'Task id: ${todo.uuid} found, need update revision: $revision ...');
        updateTask(todo: todo);
      } else {
        log.info(
            'Save Task id: ${todo.uuid} not found, need insert revision: $revision ...');
        insertTask(todo: todo);
      }
    } catch (e) {
      log.warning('Save Task: $e');
    }
    return todo;
  }

  /// INSERT Task to Server
  ///
  Future<Todo> insertTask({required Todo todo}) async {
    const String url = '${AppUrls.urlTask}/list';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Save Todo, revision: $revision body: $body ...');
    try {
      final http.Response response = await client.post(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        todo = todo.copyWith(upload: true);
        revision = result['revision'];
        log.info('Save Todo id: ${todo.uuid} revision: $revision');
      } else {
        log.info('Save Todo, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Save Todo: $e');
    }
    return todo;
  }

  /// UPDATE Task to Server
  ///
  @override
  Future<Todo> updateTask({required Todo todo}) async {
    final String url = '${AppUrls.urlTask}/list/${todo.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Update Todo id: ${todo.uuid} revision: $revision');
    try {
      final http.Response response = await client.put(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.info('Update Todo upload: ${todo.upload} revision: $revision');
      } else {
        log.info(
            'Update Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Update Todo: $e');
    }
    return todo;
  }

  /// DELETE Task From Server
  ///
  @override
  Future<Todo> deleteTask({required Todo todo}) async {
    final String url = '${AppUrls.urlTask}/list/${todo.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': todo.toJson(),
    });
    log.info('Delete Task id: ${todo.uuid} revision: $revision  body: $body');
    try {
      final http.Response response = await client.delete(
        Uri.parse(url),
        headers: {
          'X-Last-Known-Revision': revision.toString(),
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        revision = result['revision'];
        log.info('Delete Task id: ${todo.uuid} revision: $revision');
      } else {
        log.info(
            'Delete Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Delete Task: $e');
    }
    return todo;
  }

  Future<Todo> getTask({required int id}) async {
    final String url = '${AppUrls.urlTask}/list/$id';
    // TODO
    // final token = getToken();
    log.info('getAllTasksFromServer get from: $url');
    final http.Response response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final taskJson = json.decode(response.body);
      final Todo task = Todo.fromJson(taskJson);
      log.info('getTaskByIDFromServer load ${task.title} by id: $id');
      return task;
    } else {
      log.info('getAllTasksFromServer response code: ${response.statusCode}');
      throw ServerException(response.statusCode.toString());
    }
  }
}
