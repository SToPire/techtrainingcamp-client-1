import 'package:dio/dio.dart';

class Http{
  static Dio dio;

  factory Http() => _getInstance();
  static Http get instance => _getInstance();
  static Http _instance;

  static Http _getInstance(){
    if(_instance == null){
      _instance = Http._internal();
    }
    return _instance;
  }

  Http._internal(){
    dio = Dio(BaseOptions(connectTimeout:  60000, receiveTimeout: 15000, sendTimeout: 15000));
  }

  static final String key = 'fb68d358d553407fac1e920ad33ef76a';

  Future get(String path, Map<String, dynamic> params) async {
    try {
      Response response = await dio.get(path, queryParameters: params);
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future post(String path, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(path, data: data);
      return response.data;
    } catch (e) {
      return null;
    }
  }
}