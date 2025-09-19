import 'dart:io';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

/// Формат: [дата время] [LEVEL] сообщение
class SimpleLogPrinter extends LogPrinter {
  final DateFormat _timeFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  @override
  List<String> log(LogEvent event) {
    final time = _timeFormat.format(DateTime.now());
    final level = event.level.name.toUpperCase().padRight(7);
    final message = event.message;
    return ['[$time] [$level] $message'];
  }
}

/// Пишем логи по дням в отдельные файлы
class DailyFileLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) async {
    if (Platform.isMacOS) return;
    try {
      // путь к logs рядом с .exe
      final exeDir = File(Platform.resolvedExecutable).parent;
      final logsDir = Directory(p.join(exeDir.path, 'logs'));

      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final file = File(p.join(logsDir.path, '$date.log'));

      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      final sink = file.openWrite(mode: FileMode.append);
      for (var line in event.lines) {
        sink.writeln(line);
      }
      await sink.flush();
      await sink.close();
    } catch (e, st) {
      print('❌ Ошибка записи логов: $e');
      print(st);
    }
  }
}

/// Глобальный логгер: и в файл, и в консоль
final appLogger = Logger(
  printer: SimpleLogPrinter(),
  output: MultiOutput([
    ConsoleOutput(), // 👈 в консоль
    DailyFileLogOutput(), // 👈 в файл
  ]),
  level: Level.debug,
);
