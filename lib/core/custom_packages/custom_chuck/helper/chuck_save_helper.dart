import 'dart:async';
import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';

import '../helper/chuck_conversion_helper.dart';
import '../model/chuck_http_call.dart';
import '../utils/chuck_parser.dart';

class ChuckSaveHelper {
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static Future<String> _buildChuckLog() async {
    final StringBuffer stringBuffer = StringBuffer();
    final packageInfo = await PackageInfo.fromPlatform();
    stringBuffer.write('Chuck - HTTP Inspector\n');
    stringBuffer.write('App name:  ${packageInfo.appName}\n');
    stringBuffer.write('Package: ${packageInfo.packageName}\n');
    stringBuffer.write('Version: ${packageInfo.version}\n');
    stringBuffer.write('Build number: ${packageInfo.buildNumber}\n');
    stringBuffer.write('Generated: ${DateTime.now().toIso8601String()}\n');
    stringBuffer.write('\n');
    return stringBuffer.toString();
  }

  static String _buildCallLog(ChuckHttpCall call) {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('===========================================\n');
    stringBuffer.write('Id: ${call.id}\n');
    stringBuffer.write('============================================\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('General data\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Server: ${call.server} \n');
    stringBuffer.write('Method: ${call.method} \n');
    stringBuffer.write('Endpoint: ${call.endpoint} \n');
    stringBuffer.write('Client: ${call.client} \n');
    stringBuffer.write('Duration ${ChuckConversionHelper.formatTime(call.duration)}\n');
    stringBuffer.write('Secured connection: ${call.secure}\n');
    stringBuffer.write('Completed: ${!call.loading} \n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Request\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Request time: ${call.request!.time}\n');
    stringBuffer.write('Request content type: ${call.request!.contentType}\n');
    stringBuffer.write('Request cookies: ${_encoder.convert(call.request!.cookies)}\n');
    stringBuffer.write('Request headers: ${_encoder.convert(call.request!.headers)}\n');
    if (call.request!.queryParameters.isNotEmpty) {
      stringBuffer.write('Request query params: ${_encoder.convert(call.request!.queryParameters)}\n');
    }
    stringBuffer.write('Request size: ${ChuckConversionHelper.formatBytes(call.request!.size)}\n');
    stringBuffer.write(
        'Request body: ${ChuckParser.formatBody(call.request!.body, ChuckParser.getContentType(call.request!.headers))}\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Response\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Response time: ${call.response!.time}\n');
    stringBuffer.write('Response status: ${call.response!.status}\n');
    stringBuffer.write('Response size: ${ChuckConversionHelper.formatBytes(call.response!.size)}\n');
    stringBuffer.write('Response headers: ${_encoder.convert(call.response!.headers)}\n');
    stringBuffer.write(
        'Response body: ${ChuckParser.formatBody(call.response!.body, ChuckParser.getContentType(call.response!.headers))}\n');
    if (call.error != null) {
      stringBuffer.write('--------------------------------------------\n');
      stringBuffer.write('Error\n');
      stringBuffer.write('--------------------------------------------\n');
      stringBuffer.write('Error: ${call.error!.error}\n');
      if (call.error!.stackTrace != null) {
        stringBuffer.write('Error stacktrace: ${call.error!.stackTrace}\n');
      }
    }
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write('Curl\n');
    stringBuffer.write('--------------------------------------------\n');
    stringBuffer.write(call.getCurlCommand());
    stringBuffer.write('\n');
    stringBuffer.write('==============================================\n');
    stringBuffer.write('\n');

    return stringBuffer.toString();
  }

  static Future<String> buildCallLog(ChuckHttpCall call) async {
    try {
      return await _buildChuckLog() + _buildCallLog(call);
    } catch (exception) {
      return 'Failed to generate call log';
    }
  }
}
