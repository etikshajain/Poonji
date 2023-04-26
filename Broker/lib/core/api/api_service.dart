import 'package:dio/dio.dart';
import 'api_response.dart';


abstract class IApiService{
  Future<T> getModelled<T>({
    required String endpoint, JSON? queryParameters,
    bool requiresAuthToken = true,
    required T Function(JSON response) converter
  });

  Future<Response> get({
    required String endpoint, JSON? queryParameters,
    bool requiresAuthToken = true,
  });

  Future<List<T>> getCollection<T>({
    required String endpoint,
    JSON? queryParameters,
    bool requiresAuthToken = true,
    required T Function(JSON responseBody) converter,
  });

  Future<T> post<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  });
  Future<T> delete<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  });
  Future<T> patch<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  });

  void addToken(String token);
}

class ApiService extends IApiService{
  final Dio dio;

  addToken(String token){
    dio.options.headers['Authorization']= 'Bearer $token';
  }

  removeToken(){
    dio.options.headers['Authorization']= null;
  }


  ApiService({
    required this.dio,
  });
  @override
  Future<T> getModelled<T>({
    required String endpoint, JSON? queryParameters,
    bool requiresAuthToken = true,
    required T Function(JSON response) converter
  })async{
    JSON body;
    int? statusCode;
    try{
      final response = await dio.get(endpoint,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      body = response.data;
      statusCode = response.statusCode;

    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
    if(statusCode != 200){
      throw ApiException(body['error'], statusCode: statusCode);
    }
    try {
      return converter(body);
    } on Exception catch (ex) {
      throw ApiException.fromParsing(ex);
    }
  }

  @override
  Future<List<T>> getCollection<T>({
    required String endpoint,
    JSON? queryParameters,
    bool requiresAuthToken = true,
    required T Function(JSON responseBody) converter,
  })async{
    List body;
    try{
      final response = await dio.get(endpoint,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      body = response.data;
      if(response.statusCode != 200){
        throw ApiException(response.data['error'], statusCode: response.statusCode);
      }
    }on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
    try {
      return body.map((dataMap) => converter(dataMap! as JSON)).toList();
    } on Exception catch (ex) {
      throw ApiException.fromParsing(ex);
    }
  }

  @override
  Future<T> post<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  })async{
    JSON body;
    int? statusCode;
    try{
      final response = await dio.post(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      body = response.data;
      statusCode = response.statusCode;
    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
    if(statusCode != successStatus){
      throw ApiException(body['error'], statusCode: statusCode);
    }
    try {
      return converter(body);
    } on Exception catch (ex) {
      throw ApiException.fromParsing(ex);
    }
  }

  @override
  Future<T> delete<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  })async{
    JSON body;
    int? statusCode;
    try{
      final response = await dio.delete(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      body = response.data;
      statusCode = response.statusCode;
    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
    if(statusCode != successStatus){
      throw ApiException(body['error'], statusCode: statusCode);
    }
    try {
      return converter(body);
    } on Exception catch (ex) {
      throw ApiException.fromParsing(ex);
    }
  }

  @override
  Future<T> patch<T>({
    required String endpoint, JSON? queryParameters,
    required JSON data,
    bool requiresAuthToken = true,
    int successStatus = 201,
    required T Function(JSON response) converter
  })async{
    JSON body;
    int? statusCode;
    try{
      final response = await dio.patch(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      body = response.data;
      statusCode = response.statusCode;
    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
    if(statusCode != successStatus){
      throw ApiException(body['error'], statusCode: statusCode);
    }
    try {
      return converter(body);
    } on Exception catch (ex) {
      throw ApiException.fromParsing(ex);
    }
  }

  @override
  Future<Response> get({required String endpoint, JSON? queryParameters, bool requiresAuthToken = true}) async{
    try{
      final response = await dio.get(endpoint,
        queryParameters: queryParameters,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      return response;
    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
  }

}
