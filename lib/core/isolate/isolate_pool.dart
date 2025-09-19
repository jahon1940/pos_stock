import 'isolate_worker.dart';

class IsolatePool {
  final int size;
  final List<IsolateWorker> _workers = [];
  int _currentWorkerIndex = 0;

  IsolatePool(this.size);

  Future<void> initialize() async {
    if (_workers.isNotEmpty) {
      return;
    }
    for (var i = 0; i < size; i++) {
      final worker = await IsolateWorker.create();
      _workers.add(worker);
    }
  }

  Future<T> execute<T>(dynamic task, T Function(dynamic) converter) async {
    final worker = _getNextWorker();
    return await worker.execute<T>(task, converter);
  }

  IsolateWorker _getNextWorker() {
    final worker = _workers[_currentWorkerIndex];
    _currentWorkerIndex = (_currentWorkerIndex + 1) % _workers.length;
    return worker;
  }

  Future<void> dispose() async {
    for (final worker in _workers) {
      await worker.dispose();
    }
  }
}
