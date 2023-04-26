import 'package:broker/core/api/api_service.dart';
import 'package:broker/core/api/endpoints.dart';
import 'package:broker/db.dart';
import 'package:broker/services/auth_service.dart';
import 'package:broker/services/broke_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:network_layer/network_layer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
final sl = GetIt.instance;

Future<void> init()async{
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl,))
    ..options.connectTimeout = Duration(milliseconds: 5000) // 5 seconds
    ..options.receiveTimeout = Duration(milliseconds: 3000);
  dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0NDcwMWU0NTBiYWI2NTg4NDFmNTE5MCIsIm5hbWUiOiJBamVldCBLdW1hciIsImVtYWlsIjoiYWplZXQzQGdtYWlsLmNvbSIsInVwaV9pZCI6Ijk3MTIwOTU4NzA5MTFAcGF5dG0iLCJ1c2VyX2lkIjoicG9zaF9kZXRlY3RvciIsImlzS1lDVmVyaWZpZWQiOmZhbHNlLCJjcmVkaWJpbGl0eV9zY29yZSI6MCwiaWF0IjoxNjgyMzc1NDg0LCJleHAiOjE2ODc1NTk0ODR9.uflkbCleCky8fADziO3rUT-7n8GuLqtoq6oVCirxahw';
  dio.interceptors.add(PrettyDioLogger(
    request: true,
    responseBody: true,
    responseHeader: true,
    requestBody: true,
    requestHeader: true,
    error: true,
  ));

  sl.registerLazySingleton(() => SharedPref(preferences));
  sl.registerLazySingleton<IApiService>(() => ApiService(
      dio: dio));

  final cachePath = (await getApplicationDocumentsDirectory()).path;
  sl.registerLazySingleton(() => DioService(dioClient: dio,cachePath: cachePath,));

  await services();
  await cubits();
}

services()async{
  sl.registerLazySingleton(() => BrokeService(sl()));
  sl.registerLazySingleton(() => AuthService(sl()));
}

cubits()async{

}
