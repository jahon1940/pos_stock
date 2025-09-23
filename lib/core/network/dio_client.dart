import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/isolate/isolate_pool.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';
import 'package:injectable/injectable.dart';

import '../logging/app_logger.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

@lazySingleton
class DioClient {
  Dio? _dio;

  final _isolatePool = IsolatePool(4);

  Future<void> createDio() async {
    await _isolatePool.initialize();
    await getIt<UserDataService>().init();
    final token = getIt<UserDataService>().token.value;

    _dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Device-Token': 'Kanstik $token',
        },
        receiveTimeout: const Duration(minutes: 10),
        connectTimeout: const Duration(minutes: 10),
        extra: {'cache-control': 'public, max-age=3600'},
      ),
    )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    (_dio?.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      // Эта строка говорит клиенту принимать любые, даже недействительные, сертификаты
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<T> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    ResponseConverter<T>? converter,
    bool isIsolate = true,
    bool isShowError = true,
    CancelToken? cancelToken,
  }) async {
    try {
      if (_dio == null) {
        await createDio();
      }

      late Response response;
      final headers = _dio!.options.headers;

      response = await _dio!.get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(headers: headers),
      );

      if (converter == null) return response.data;

      if (response.data is String) {
        if (response.data.isNotEmpty) return response.data;

        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        if (response.data == null) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
          );
        }
        return converter(response.data);
      }

      final result = await _isolatePool.execute<T>(
        response.data as dynamic,
        converter,
      );

      return result;
    } on DioException catch (e) {
      appLogger.e('GET REQUEST', error: e, stackTrace: e.stackTrace);

      if (cancelToken?.isCancelled ?? false) {
        throw e.copyWith(message: 'Request cancelled');
      }

      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }

        rethrow;
      }

      rethrow;
    } catch (e, s) {
      appLogger.e('GET REQUEST', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<T> postRequest<T>(
    String url, {
    Object? data,
    ResponseConverter<T>? converter,
    Map<String, dynamic>? queryParameters,
    bool isIsolate = true,
    bool isShowError = true,
    Map<String, dynamic>? additionalHeaders,
    CancelToken? cancelToken,
  }) async {
    appLogger.i("POST REQUEST $url $data");
    if (_dio == null) {
      await createDio();
    }
    try {
      final headers = _dio!.options.headers;

      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
      Response response;

      response = await _dio!.post(
        url,
        data: data,
        options: Options(headers: headers),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      appLogger.i("POST RESPONSE ${response.statusCode} ${response.data}");

      if (converter == null) return response.data;

      if (!isIsolate) {
        return converter(response.data);
      }

      final result = await _isolatePool.execute<T>(
        response.data as dynamic,
        converter,
      );
      return result;
    } on DioException catch (e) {
      appLogger.e('POST REQUEST', error: e, stackTrace: e.stackTrace);
      if (cancelToken?.isCancelled ?? false) {
        rethrow;
      }
      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> patchRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    ResponseConverter<T>? converter,
    bool isIsolate = true,
    bool isShowError = true,
    CancelToken? cancelToken,
  }) async {
    try {
      if (_dio == null) {
        await createDio();
      }
      final response = await _dio!.patch(
        url,
        data: data,
        cancelToken: cancelToken,
      );

      if (converter == null) return response.data;

      if (!isIsolate) {
        return converter(response.data);
      }

      final result = await _isolatePool.execute<T>(
        response.data as dynamic,
        converter,
      );
      return result;
    } on DioException catch (e) {
      if (cancelToken?.isCancelled ?? false) {
        rethrow;
      }
      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }
      }

      rethrow;
    } catch (e, s) {
      appLogger.e('POST REQUEST', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<T> putRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    ResponseConverter<T>? converter,
    Map<String, dynamic>? queryParameters,
    bool isIsolate = true,
    bool isShowError = true,
    CancelToken? cancelToken,
  }) async {
    try {
      if (_dio == null) {
        await createDio();
      }

      final response = await _dio!.put(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      if (converter == null) return response.data;

      if (!isIsolate) {
        return converter(response.data);
      }

      final result = await _isolatePool.execute<T>(
        response.data as dynamic,
        converter,
      );
      return result;
    } on DioException catch (e) {
      if (cancelToken?.isCancelled ?? false) {
        rethrow;
      }
      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }
      }

      rethrow;
    }
  }

  Future<T> deleteRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    ResponseConverter<T>? converter,
    Map<String, dynamic>? queryParameters,
    bool isIsolate = true,
    bool isShowError = true,
    CancelToken? cancelToken,
  }) async {
    try {
      if (_dio == null) {
        await createDio();
      }

      late Response response;

      if (data?['request_id'] != null && url.split('/').last.startsWith('devices')) {
        response = await Dio().delete(
          url,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
      } else {
        response = await _dio!.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
      }

      if (converter == null) return response.data;

      if (!isIsolate) {
        return converter(response.data);
      }

      final result = await _isolatePool.execute<T>(
        response.data as dynamic,
        converter,
      );
      return result;
    } on DioException catch (e) {
      if (cancelToken?.isCancelled ?? false) {
        rethrow;
      }
      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }
      }
      rethrow;
    }
  }

  Future<void> downloadRequest(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    bool isShowError = true,
    CancelToken? cancelToken,
  }) async {
    try {
      if (_dio == null) {
        await createDio();
      }

      await _dio!.download(
        url,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (cancelToken?.isCancelled ?? false) {
        rethrow;
      }

      if (e.response?.data is String?) {
        if (isShowError && e.response?.statusCode != 401) {
          showErrorInfoBar(e.type);
        }
      }
      rethrow;
    }
  }

  void setAuthToken(String? token) {
    if (_dio == null) return;

    if (token == null) {
      _dio!.options.headers.remove('Device-Token');
      return;
    }

    _dio!.options.headers['Device-Token'] = 'Kanstik $token';
  }

  void setLang(String? profileId) {
    if (_dio == null) return;

    if (profileId == null) {
      _dio!.options.headers.remove('Accept-Language');
      return;
    }

    _dio!.options.headers['Accept-Language'] = profileId;
  }

  void setFormData(bool isFormData) {
    if (_dio == null) return;

    if (isFormData) {
      _dio!.options.headers['Content-Type'] = 'multipart/form-data';
      return;
    }

    _dio!.options.headers['Content-Type'] = 'application/json';
  }

  void showErrorInfoBar(DioExceptionType type) {
    if ([
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
    ].contains(type)) {}
  }
}
