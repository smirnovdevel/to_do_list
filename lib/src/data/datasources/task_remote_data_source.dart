import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../config/common/app_urls.dart';
import '../../domain/models/task.dart';
import '../../utils/error/exception.dart';

final Logger log = Logger('TaskRemoteDataSource');

abstract class ITaskRemoteDataSource {
  /// Calls the https://beta.mrdekk.ru/todobackend endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TaskModel>> getAllTasksFromServer();
  Future<TaskModel> getTaskByIDFromServer({required int id});
  Future<TaskModel> postTaskToServer({required TaskModel task});
}

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  TaskRemoteDataSource({required this.client});
  final http.Client client;
  int? revision;

  final String token = 'antievolutional';

  /// Get ALL Task from Server
  ///
  @override
  Future<List<TaskModel>> getAllTasksFromServer() async {
    const String url = '${AppUrls.urlTask}/list';
    final List<TaskModel> tasksList = [];
    // TODO
    // final token = getToken();

    log.info('Get ALL Tasks from: $url ...');
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
          tasksList.add(TaskModel.fromJson(task));
          i++;
        }
        revision = result['revision'];
        log.info(
            'Get ALL Tasks, load ${tasksList.length} tasks revision: $revision');
      } else {
        log.info('Get ALL Tasks, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Get ALL Tasks: $e');
    }
    return tasksList;
  }

  /// ADD Task to Server
  ///
  @override
  Future<TaskModel> postTaskToServer({required TaskModel task}) async {
    const String url = '${AppUrls.urlTask}/list';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('ADD Task, revision: $revision body: $body');
    try {
      final http.Response response = await client.post(
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
        task.upload = true;
        log.info('ADD Task id: ${task.uuid} revision: $revision');
      } else {
        log.info(
            'ADD Task, response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('ADD Task: $e');
    }
    return task;
  }

  /// UPDATE Task to Server
  ///
  Future<TaskModel> updateTaskToServer({required TaskModel task}) async {
    final String url = '${AppUrls.urlTask}/list/${task.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('UPDATE Task id: ${task.uuid} revision: $revision  body: $body');
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
        task.upload = true;
        log.info('UPDATE Task id: ${task.uuid} revision: $revision');
      } else {
        log.info(
            'UPDATE Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('UPDATE Task: $e');
    }
    return task;
  }

  /// DELETE Task From Server
  ///
  Future<TaskModel> deleteTaskFromServer({required TaskModel task}) async {
    final String url = '${AppUrls.urlTask}/list/${task.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('DELETE Task id: ${task.uuid} revision: $revision  body: $body');
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
        task.upload = true;
        log.info('DELETE Task id: ${task.uuid} revision: $revision');
      } else {
        log.info(
            'DELETE Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('DELETE Task: $e');
    }
    return task;
  }

  @override
  Future<TaskModel> getTaskByIDFromServer({required int id}) async {
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
      final TaskModel task = TaskModel.fromJson(taskJson);
      log.info('getTaskByIDFromServer load ${task.title} by id: $id');
      return task;
    } else {
      log.info('getAllTasksFromServer response code: ${response.statusCode}');
      throw ServerException(response.statusCode.toString());
    }
  }
}
