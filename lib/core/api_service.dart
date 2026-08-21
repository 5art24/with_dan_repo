import 'package:dio/dio.dart';
class ApiService {
  final Dio _dio;

  // 1. الرابط الأساسي للباك إند (ملاحظة: محاكي أندرويد يستبدل localhost بـ 10.0.2.2)
  static const String _baseUrl = 'http://10.0.2.2:8000/api/'; 

  // 2. التوكن المؤقت للاختبار
  static const String _token = '3|fdZoay3EQaTPxxLulch2YHb5T7IVtbnMiZb7YXEmba321169';

  ApiService(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
  }

  // GET Request
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(
      endPoint,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // POST Request
  Future<Map<String, dynamic>> post({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(
      endPoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // PUT Request
  Future<Map<String, dynamic>> put({
    required String endPoint,
    dynamic data,
  }) async {
    final response = await _dio.put(
      endPoint,
      data: data,
    );
    return response.data;
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete({
    required String endPoint,
    dynamic data,
  }) async {
    final response = await _dio.delete(
      endPoint,
      data: data,
    );
    return response.data;
  }
}