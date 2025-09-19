import 'dart:isolate';

class IsolateWorker {
  late SendPort _sendPort;
  Isolate? _isolate;

  IsolateWorker._();

  static Future<IsolateWorker> create() async {
    final worker = IsolateWorker._();
    final ReceivePort receivePort = ReceivePort();

    worker._isolate ??= await Isolate.spawn(_entryWorker, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    worker._sendPort = sendPort;

    return worker;
  }

  Future<void> dispose() async {
    _isolate?.kill();
  }

  Future<T> execute<T>(
      dynamic task, T Function(dynamic value) converter) async {
    final responsePort = ReceivePort();

    try {
      _sendPort.send([task, converter, responsePort.sendPort]);

      final result = await responsePort.first as T;
      return result;
    } catch (e, s) {
      throw Exception('Error in isolate worker: $e $s');
    } finally {
      responsePort.close();
    }
  }

  static void _entryWorker(SendPort sendPort) {
    final ReceivePort receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final task = message[0];
      final converter = message[1] as Function(dynamic value);
      final replyPort = message[2] as SendPort;

      try {
        final result = _processTask(task, converter);
        replyPort.send(result);
      } catch (e, stackTrace) {
        replyPort.send(_IsolateError(
          message: e.toString(),
          stackTrace: stackTrace,
        ));
      }
    });
  }

  static T _processTask<T>(dynamic task, T Function(dynamic value) converter) {
    return converter(task);
  }
}

class _IsolateError {
  final String message;
  final StackTrace stackTrace;

  _IsolateError({required this.message, required this.stackTrace});
}
