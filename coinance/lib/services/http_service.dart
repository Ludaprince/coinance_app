import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    baseUrl = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$baseUrl$path";
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      print('HTTPService: unable to perform a get request.');
      print(e);
    }
  }
}