import 'dart:io';

import 'package:dio/dio.dart';
import 'client/net_client.dart'
    if (dart.library.html) "client/net_client_web.dart"
    if (dart.library.io) "client/net_client_io.dart";
import 'net_resp.dart';

class NetAction {
  static int codeBadResponse = -1;
  static int codeSendTimeout = -1001;
  static int codeReceiveTimeout = -1002;
  static int codeCancel = -1003;
  static int codeConnectionError = -1004;
  static int codeConnectionTimeout = -1005;
  static int codeBadCertificate = -1006;
  static int codeUnknown = -1007;
  static NetResp<T> Function<T>(DioException)? onError;
  static Future<NetResp<T>> _handleError<T>(
    DioException e, {
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) async {
    return (NetAction.onError ??
            (DioException it) {
              String msg = it.message ?? "";
              int code = -1;
              switch (it.type) {
                case DioExceptionType.sendTimeout:
                  msg = "发送超时";
                  code = codeSendTimeout;
                  break;
                case DioExceptionType.receiveTimeout:
                  msg = "接收超时";
                  code = codeReceiveTimeout;
                  break;
                case DioExceptionType.cancel:
                  msg = "请求被取消";
                  code = codeCancel;
                  break;
                case DioExceptionType.connectionError:
                  msg = "连接错误";
                  code = codeConnectionError;
                  break;
                case DioExceptionType.connectionTimeout:
                  msg = "连接超时";
                  code = codeConnectionTimeout;
                  break;
                case DioExceptionType.badCertificate:
                  msg = "证书错误";
                  code = codeBadCertificate;
                  break;
                case DioExceptionType.badResponse:
                  return _handleResponse(
                    it.response,
                    convertFunc: convertFunc,
                    respConvertFunc: respConvertFunc,
                  );
                case DioExceptionType.unknown:
                  msg = "${it.error}";
                  code = codeUnknown;
                  break;
              }
              return NetResp<T>(msg: msg, code: code);
            })
        .call(e);
  }

  static NetResp<T> _handleResponse<T>(
    Response? res, {
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) {
    int code = res?.statusCode ?? codeBadResponse;
    String? msg = res?.statusMessage;
    if (respConvertFunc != null) {
      return respConvertFunc.call(res);
    }
    if (convertFunc != null) {
      return convertFunc.call(res?.data);
    }
    return NetResp(data: res?.data as T, code: code, msg: msg);
  }

  static Future<NetResp<T>> _try<T>(
    Future<Response?> Function() action,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  ) async {
    Response? res;
    try {
      res = await action();
    } catch (e) {
      if (e is DioException) {
        return _handleError(e,
            convertFunc: convertFunc, respConvertFunc: respConvertFunc);
      }
      return NetResp();
    }

    return _handleResponse<T>(res,
        convertFunc: convertFunc, respConvertFunc: respConvertFunc);
  }

  static Future<NetResp<T>> get<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) =>
      _try(
          () async => await NetClient.dioClient.get(
                url,
                cancelToken: cancelToken,
                data: params,
                options: Options(
                  headers: headers,
                ),
              ),
          convertFunc,
          respConvertFunc);
  static Future<NetResp<T>> post<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) =>
      _try(
          () async => await NetClient.dioClient.post(
                url,
                cancelToken: cancelToken,
                data: params,
                options: Options(
                  headers: headers,
                ),
              ),
          convertFunc,
          respConvertFunc);

  static Future<NetResp<T>> form<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _try(
          () async => await NetClient.dioClient.post(url,
              data: params, //FormData.fromMap(params),
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              options: Options(
                  headers: headers,
                  followRedirects: false,
                  validateStatus: (code) => (code ?? 0) < 500,
                  contentType:
                      ContentType.parse("application/x-www-form-urlencoded")
                          .value)),
          convertFunc,
          respConvertFunc);
  static Future<NetResp<T>> put<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) =>
      _try(
          () async => await NetClient.dioClient.put(
                url,
                cancelToken: cancelToken,
                data: params,
                options: Options(
                  headers: headers,
                ),
              ),
          convertFunc,
          respConvertFunc);
  static Future<NetResp<T>> delete<T>(
    String url, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
  }) =>
      _try(
          () async => await NetClient.dioClient.delete(
                url,
                cancelToken: cancelToken,
                data: params,
                options: Options(
                  headers: headers,
                ),
              ),
          convertFunc,
          respConvertFunc);
  static Future<NetResp<T>> download<T>(
    String url,
    String savePath, {
    required dynamic params,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    NetResp<T> Function(Map dataMap)? convertFunc,
    NetResp<T> Function(Response? res)? respConvertFunc,
    ProgressCallback? onReceiveProgress,
  }) =>
      _try(
          () async => await NetClient.dioClient.download(url, savePath,
              queryParameters: params,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
              options: Options(
                responseType: ResponseType.stream,
                followRedirects: false,
                headers: headers,
              )),
          convertFunc,
          respConvertFunc);
}
