import 'package:dio/dio.dart';
import 'package:meilisearch/src/version.dart';
import 'http_request.dart';
import 'exception.dart';

class HttpRequestImpl implements HttpRequest {
  HttpRequestImpl(this.serverUrl, this.apiKey, [this.connectTimeout])
      : dio = Dio(BaseOptions(
          baseUrl: serverUrl,
          headers: <String, dynamic>{
            if (apiKey != null) 'Authorization': 'Bearer ${apiKey}',
            'Content-Type': 'application/json',
            'User-Agent': Version.qualifiedVersion,
          },
          responseType: ResponseType.json,
          connectTimeout: Duration(seconds: connectTimeout ?? 0),
        ));

  @override
  final String serverUrl;

  @override
  final String? apiKey;

  @override
  final int? connectTimeout;

  final Dio dio;

  @override
  Map<String, dynamic> headers() {
    return this.dio.options.headers;
  }

  @override
  Future<Response<T>> getMethod<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    var response;
    try {
      response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> postMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response;
    try {
      response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> patchMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response;
    try {
      response = await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> putMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response;
    try {
      response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> deleteMethod<T>(String path, {dynamic data}) async {
    var response;
    try {
      response = await dio.delete<T>(
        path,
        data: data,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  throwException(DioError e) {
    if (e.type == DioErrorType.badResponse) {
      throw MeiliSearchApiException.fromHttpBody(e.message??"unknown error", e.response?.data);
    } else {
      throw CommunicationException(e.message??"unknown error");
    }
  }
}
