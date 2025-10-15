// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../chuck.dart';

extension ChuckHttpClientExtensions on Future<HttpClientRequest> {
  /// Intercept http client with Chuck. This extension method provides additional
  /// helpful method to intercept httpClientResponse.
  Future<HttpClientResponse> interceptWithChuck(
    Chuck chuck, {
    dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    final HttpClientRequest request = await this;
    if (body != null) {
      request.write(body);
    }
    if (headers != null) {
      headers.forEach(
        (String key, dynamic value) {
          request.headers.add(key, value as Object);
        },
      );
    }
    chuck.onHttpClientRequest(request, body: body);
    final httpResponse = await request.close();
    final responseBody = await utf8.decoder.bind(httpResponse).join();
    chuck.onHttpClientResponse(httpResponse, request, body: responseBody);
    return httpResponse;
  }
}
