import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class NetClient {
  static Dio get dioClient => DioForNative();
}
