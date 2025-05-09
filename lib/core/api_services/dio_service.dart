import 'package:dio/dio.dart';
import 'package:usercraft/core/api_services/end_points.dart';
import 'dio_prety.dart';

// ignore: constant_identifier_names
enum HttpMethod { Get, Post, Put, Patch, Delete }

class NetworkManager {
  static final NetworkManager _singleton = NetworkManager._internal();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal();

  Dio dio = Dio();

  void setDioOptions() {
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.contentType = Headers.jsonContentType;
  }

  Future<Response?> callApi({
    required HttpMethod method,
    required String? urlEndPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    setDioOptions();
    DioLoggerService.attachLoggerInterceptor(dio);

    String requestURL = EndPoints.baseUrl + urlEndPoint!;

    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Api-Key': 'reqres-free-v1'
    };

    Response? response;
    try {
      switch (method) {
        case HttpMethod.Get:
          response = await dio.get(
            requestURL,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.Post:
          response = await dio.post(
            requestURL,
            queryParameters: queryParameters,
            data: body,
          );
          break;
        case HttpMethod.Put:
          response = await dio.put(
            requestURL,
            queryParameters: queryParameters,
            data: body,
          );
          break;
        case HttpMethod.Delete:
          response = await dio.delete(requestURL, data: body);
          break;
        default:
          break;
      }

      if (response?.statusCode == 200) {
        return response;
      }
    } on DioError catch (errorResponse) {
      return errorResponse.response;
    }
    return response;
  }
}
