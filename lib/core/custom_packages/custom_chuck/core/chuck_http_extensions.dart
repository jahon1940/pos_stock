// ignore_for_file: depend_on_referenced_packages, directives_ordering

import '../chuck.dart';
import 'package:http/http.dart';

extension ChuckHttpExtensions on Future<Response> {
  /// Intercept http request with Chuck. This extension method provides additional
  /// helpful method to intercept https' response.
  Future<Response> interceptWithChuck(Chuck chuck, {dynamic body}) async {
    final Response response = await this;
    chuck.onHttpResponse(response, body: body);
    return response;
  }
}
