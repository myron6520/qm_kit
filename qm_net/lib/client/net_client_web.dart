import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

class NetClient {
  static Dio get dioClient => DioForBrowser();
}
