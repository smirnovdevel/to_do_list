import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../config/common/app_urls.dart';
import '../../domain/models/task.dart';
import '../../utils/error/exception.dart';
import 'impl_data_source.dart';

final Logger log = Logger('RemoteDataSource');

class TaskRemoteDataSource implements ImplTaskDataSource {
  TaskRemoteDataSource({required this.client});
  final http.Client client;
  int? revision;

  final String token = 'antievolutional';

  /// Get ALL Task from Server
  ///
  @override
  Future<List<TaskModel>> getTasks() async {
    const String url = '${AppUrls.urlTask}/list';
    final List<TaskModel> tasksList = [];
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
          tasksList.add(TaskModel.fromJson(task));
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
  Future<TaskModel> saveTask({required TaskModel task}) async {
    final String url = '${AppUrls.urlTask}/list/${task.uuid}';
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
            'Task id: ${task.uuid} found, need update revision: $revision ...');
        updateTask(task: task);
      } else {
        log.info(
            'Save Task id: ${task.uuid} not found, need insert revision: $revision ...');
        insertTask(task: task);
      }
    } catch (e) {
      log.warning('Save Task: $e');
    }
    return task;
  }

  /// INSERT Task to Server
  ///
  Future<TaskModel> insertTask({required TaskModel task}) async {
    const String url = '${AppUrls.urlTask}/list';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('Save Task, revision: $revision body: $body ...');
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
        revision = result['revision'];
        task.upload = true;
        log.info('Save Task id: ${task.uuid} revision: $revision');
      } else {
        log.info('Save Task, response code: ${response.statusCode}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Save Task: $e');
    }
    return task;
  }

  /// UPDATE Task to Server
  ///
  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    final String url = '${AppUrls.urlTask}/list/${task.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('Update Task id: ${task.uuid} revision: $revision  body: $body');
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
        log.info('Update Task id: ${task.uuid} revision: $revision');
      } else {
        log.info(
            'Update Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Update Task: $e');
    }
    return task;
  }

  /// DELETE Task From Server
  ///
  @override
  Future<TaskModel> deleteTask({required TaskModel task}) async {
    final String url = '${AppUrls.urlTask}/list/${task.uuid}';
    // TODO
    // final token = getToken();
    final String body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('Delete Task id: ${task.uuid} revision: $revision  body: $body');
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
        log.info('Delete Task id: ${task.uuid} revision: $revision');
      } else {
        log.info(
            'Delete Task response code: ${response.statusCode} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('Delete Task: $e');
    }
    return task;
  }

  Future<TaskModel> getTask({required int id}) async {
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
