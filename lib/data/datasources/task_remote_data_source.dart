import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:to_do_list/models/task.dart';

import '../../common/app_utls.dart';
import '../../core/error/exception.dart';

final log = Logger('ITaskRemoteDataSource');

abstract class ITaskRemoteDataSource {
  /// Calls the https://beta.mrdekk.ru/todobackend endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TaskModel>> getAllTasksFromServer();
  Future<TaskModel> getTaskByIDFromServer({required int id});
  Future<TaskModel> postTaskToServer({required TaskModel task});
}

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  final http.Client client;
  int? revision;

  final token = 'antievolutional';

  TaskRemoteDataSource({required this.client});

  @override
  Future<List<TaskModel>> getAllTasksFromServer() async {
    const String url = '${AppUrls.urlTask}/list';
    final List<TaskModel> tasksList = [];
    // TODO
    // final token = getToken();

    log.info('getAllTasksFromServer get from: $url');
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        for (Map<String, dynamic> task in result['list']) {
          tasksList.add(TaskModel.fromJson(task));
        }
        revision = result['revision'];
        log.info(
            'getAllTasksFromServer load ${tasksList.length} tasks revision: $revision');
      } else {
        log.info(
            'getAllTasksFromServer response code: ${response.statusCode.toString()}');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('getAllTasksFromServer ${e.toString()}');
    }
    return tasksList;
  }

  @override
  Future<TaskModel> postTaskToServer({required TaskModel task}) async {
    const String url = '${AppUrls.urlTask}/list';
    // TODO
    // final token = getToken();
    final body = jsonEncode({
      'element': task.toJson(),
    });
    log.info('postTaskToServer post revision: $revision body: $body');
    try {
      final response = await client.post(
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
        log.info(
            'postTaskToServer post task id: ${task.id} revision: $revision');
      } else {
        log.info(
            'postTaskToServer response code: ${response.statusCode.toString()} revision: $revision');
        throw ServerException(response.statusCode.toString());
      }
    } catch (e) {
      log.warning('postTaskToServer ${e.toString()}');
    }
    return task;
  }

  @override
  Future<TaskModel> getTaskByIDFromServer({required int id}) async {
    final String url = '${AppUrls.urlTask}/list/$id';
    // TODO
    // final token = getToken();
    log.info('getAllTasksFromServer get from: $url');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final taskJson = json.decode(response.body);
      final task = TaskModel.fromJson(taskJson);
      log.info('getTaskByIDFromServer load ${task.title} by id: $id');
      return task;
    } else {
      log.info(
          'getAllTasksFromServer response code: ${response.statusCode.toString()}');
      throw ServerException(response.statusCode.toString());
    }
  }
}
