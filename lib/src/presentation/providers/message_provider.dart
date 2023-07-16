import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('MessageStateHolder');

final messageStateProvider =
    StateNotifierProvider<MessageStateHolder, MessageNotifierState>(
        (ref) => MessageStateHolder());

class MessageNotifierState {
  final String? error;
  final String? info;

  /// .... other properties of the state
  final bool loading;

  const MessageNotifierState({this.loading = false, this.error, this.info});

  MessageNotifierState copyWith({String? error, String? info, bool? loading}) {
    return MessageNotifierState(
        error: error ?? this.error,
        info: info ?? this.info,
        loading: loading ?? this.loading);
  }
}

class MessageStateHolder extends StateNotifier<MessageNotifierState> {
  MessageStateHolder() : super(const MessageNotifierState());

  Future<void> warning(String message) async {
    state = state.copyWith(loading: true, error: '');
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(loading: false, error: message);
  }

  Future<void> info(String message) async {
    state = state.copyWith(loading: true, info: '');
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(loading: false, info: message);
  }
}
