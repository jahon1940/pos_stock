// ignore_for_file: prefer_single_quotes, use_raw_strings

import 'chuck_http_error.dart';
import 'chuck_http_request.dart';
import 'chuck_http_response.dart';

class ChuckHttpCall {
  final int id;
  late DateTime createdTime;
  String client = "";
  bool loading = true;
  bool secure = false;
  String method = "";
  String endpoint = "";
  String server = "";
  String uri = "";
  int duration = 0;

  ChuckHttpRequest? request;
  ChuckHttpResponse? response;
  ChuckHttpError? error;

  ChuckHttpCall(this.id) {
    loading = true;
    createdTime = DateTime.now();
  }

  void setResponse(ChuckHttpResponse response) {
    this.response = response;
    loading = false;
  }

  String getCurlCommand() {
    var compressed = false;
    var curlCmd = "curl";
    curlCmd += " -X $method";
    final headers = request!.headers;
    headers.forEach((key, dynamic value) {
      if ("Accept-Encoding" == key && "gzip" == value) {
        compressed = true;
      }
      curlCmd += " -H '$key: $value'";
    });

    final String requestBody = request!.body.toString();
    if (requestBody != '') {
      // try to keep to a single line and use a subshell to preserve any line breaks
      curlCmd += " --data \$'${requestBody.replaceAll("\n", "\\n")}'";
    }

    final queryParamMap = request!.queryParameters;
    int paramCount = queryParamMap.keys.length;
    var queryParams = "";
    if (paramCount > 0) {
      queryParams += "?";
      queryParamMap.forEach((key, dynamic value) {
        queryParams += '$key=$value';
        paramCount -= 1;
        if (paramCount > 0) {
          queryParams += "&";
        }
      });
    }

    // If server already has http(s) don't add it again
    if (server.contains("http://") || server.contains("https://")) {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'$server$endpoint$queryParams'"}";
    } else {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'${secure ? 'https://' : 'http://'}$server$endpoint$queryParams'"}";
    }

    return curlCmd;
  }
}
