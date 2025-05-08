import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:usercraft/core/api/end_points.dart';
import 'package:usercraft/core/api/storage_conts.dart';
import 'package:usercraft/model/responce_model.dart';

import 'dio_prety.dart';

// ================================ is function ko call krna h ================================
// final response = await NetworkManager().callApi(
//         urlEndPoint: ApiConstants.forgotPassword,            // api url
//         method: HttpMethod.Post,                             // api method
//         body: body,                                          //  api body
//       );

class AppConfig {}

// ignore: constant_identifier_names
enum HttpMethod { Get, Post, Put, Patch, Delete }

class NetworkManager {
  List<Cookie> cookies = [];
  static final NetworkManager _singleton = NetworkManager._internal();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal();

  Dio dio = Dio();

  void setDioOptions() {
    dio.options.connectTimeout = 200000;
    dio.options.receiveTimeout = 200000;
    dio.options.contentType = Headers.jsonContentType;
  }

  static Map<String, String> getHeaders() {
    final token = GetStorage().read(StorageConstants.token);
    return {
      'Authorization': 'Bearer $token ',
      'Accept': 'application/json',
    };
  }

  Future<Response?> callApi(
      {required HttpMethod method,
      required String? urlEndPoint,
      Map<String, dynamic>? queryParameters,
      Options? options,
      String? fullUrl,
      bool addToken = true,
      dynamic token,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      dynamic body,
      bool isProgressing = true,
      bool isFormDataRequest = false,
      FormData? formData,
      bool isLoading = true,
      bool isGetCookie = false,
      ProgressCallback? onSendProgress,
      BuildContext? context}) async {
    this.setDioOptions();

    // Replace the existing logger with our pretty logger
    DioLoggerService.attachLoggerInterceptor(dio);

    var requestURL;
    /*  String ip = await PrefManager().read(AppKeys.IP);
     if (ip != '') {      requestURL = 'http://$ip/api/' + urlEndPoint!;
    } else {
      requestURL = AppConfig.baseUrlProduction + urlEndPoint!;
    } */
    requestURL = EndPoints.baseUrl + urlEndPoint!;

    // if (urlEndPoint == "/api/logout") {
    //   dio.options.headers = {
    //     "Content-Type": "multipart/form-data",
    //   };
    // }

    if (isFormDataRequest) {
      dio.options.headers = {
        "Content-Type": "multipart/form-data",
        //'Cookie': 'XDEBUG_SESSION=PHPSTORM'
      };
    }
    if (GetStorage().read(StorageConstants.token) != null) {
      dio.options.headers = {
        'Authorization': 'Bearer ${GetStorage().read(StorageConstants.token)}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        //'Cookie': 'XDEBUG_SESSION=PHPSTORM'
      };

      print(GetStorage().read(StorageConstants.token));
    } else if (addToken && token != null) {
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        // 'Content-Type': 'application/json',
        // 'Accept': 'application/json'
      };
    } else {
      dio.options.headers = {
        'Accept': 'application/json'
        //'Cookie': 'XDEBUG_SESSION=PHPSTORM'
      };
    }
    /* dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError e, handler) async {
          //  if (e.isConnectionError()) {
         // Utils.hideLoader();
          EasyLoading.dismiss();

          getx.Get.snackbar(

              'Network Error', 'Please check your network connection',
              snackPosition: getx.SnackPosition.TOP,
              colorText: Colors.white,
              backgroundColor: ConstantColor.primaryColorRed);
          // globalBloc.showConnectionErrorSnackBar();
          /*   return handler.next(e);
          } */

          return handler.next(e);
        },
      ),
    ); */
    /*  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    }; */
    /*  dio.options.headers = {
        'Authorization':'Basic ZTYxZTc2OTJiOWY3OTk5MzE4ZGRmM2FhZDViMjhlODg0MzI1YWJkMzplNjU4YWUyODQ2ODY5NzQ2YTZiMDE2YjFjZWJlNmMyYTk3Yzg2ZTk0',

        //'Cookie': 'XDEBUG_SESSION=PHPSTORM'
      }; */
    Response? response;
    try {
      if (isLoading) {
        /// Utils.showLoader();
        //  EasyLoading.show();
      }
      switch (method) {
        case HttpMethod.Get:
          response = await dio.get(
            requestURL,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.Post:
          response = await dio.post(
            requestURL,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            data: isFormDataRequest ? formData : body,
          );
          break;
        case HttpMethod.Put:
          response = await dio.put(
            requestURL,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            data: body,
          );
          break;
        case HttpMethod.Patch:
          break;
        case HttpMethod.Delete:
          response = await dio.delete(requestURL, data: body);
          break;
      }
      // EasyLoading.dismiss();
      //Utils.hideLoader();
      // EasyLoading.dismiss();

      if (response?.statusCode == 200) {
        if (method == HttpMethod.Post || method == HttpMethod.Put) {
          final ResponceModel baseModel =
              ResponceModel.fromJson(response!.data);
          // if (baseModel.message != null) {
          //   Fluttertoast.showToast(
          //     msg: baseModel.message.toString(),
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0,
          //   );
          // }
        }
        return response;
      }
      // } else {
      //   final BaseModel baseModel = BaseModel.fromJson(response!.data);
      //   Fluttertoast.showToast(
      //       msg: baseModel.message.toString(),
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.TOP,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: const Color(0xFF003DB3),
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   return response;
      // }
    } on DioError catch (errorResponse) {
      //Utils.hideLoader();
      /*  EasyLoading.dismiss();
      if (errorResponse.response!.statusCode == 401) {
        if (context != null) {
          Utils.goToNextScreen(context, WelcomeScreen());
          //  context.go('/${WelcomeScreen.namep}');
        }
      }*/
      // ErrorModel baseModel = ErrorModel.fromJson(errorResponse.response?.data);
      if (errorResponse.response?.statusCode == 400
          // baseModel.message == 'Please Enter OTP.'
          ) {
        return errorResponse.response;
      }

      // Fluttertoast.showToast(
      //     msg: 'Wrong credential',
      //     // msg: baseModel.message.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.blue,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return errorResponse.response?.data;
      //EasyLoading.dismiss();
      // Map<String, dynamic> errorResponse = error.response.data;
      /*  if (error.response.statusCode == 401) {
        //  Fluttertoast.showToast(msg: 'Please entter a valid code');
      } */

      // Response errResponse =
      //   Response(data: errorResponse, statusCode: error.response.statusCode);
      //return error.response;
      // throw ApiException(error);
    }
  }
}

extension ErrorHandling on DioError {
  /// [false] for connection errors etc
  /// [true] for anything with a status code -- proper HTTP API errors
  bool isHttpError() {
    // return this.response.statusCode != null;
    return this.type == DioErrorType.response;
  }

  bool isConnectionError() {
    if (this.type == DioErrorType.other &&
        this.response == null &&
        this.error == null) {
      return true;
    }
    // Triggers for connection refused
    if (this.type == DioErrorType.other && this.error is SocketException)
      return true;
    // This can happen because we grab Firebase token inside a Dio listener

    return [
      DioErrorType.sendTimeout,
      DioErrorType.receiveTimeout,
      DioErrorType.connectTimeout,

      // Can happen when connection is off, DNS errors
      // Note we're assuming it's a connection error, it's probably true
      // Still, might want to behave differently in some cases if connection is off
      // A list so far:
      // - HttpException, uri = ..
      // - SocketException: OS Error: Connection refused
      // - HandshakeException: Connection terminated during handshake
      DioErrorType.other,
    ].contains(this.type);
  }

  bool isRequestSent() {
    return ![
      DioErrorType.other,
      DioErrorType.connectTimeout,
      DioErrorType.sendTimeout
    ].contains(this.type);
  }
}
