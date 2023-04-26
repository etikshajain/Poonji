import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

typedef JSON = Map<String, dynamic>;

class ApiException extends Equatable implements Exception{
  final int? statusCode;
  final String message;
  ApiException(this.message,{this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  /// 1. on no internet : DioErrorType.unknown --> ex.error.toString().contains(SocketException)
  /// 2. on invalid url : DioErrorType.badResponse --> ex.message.contains(404)
  factory ApiException.fromDio(Exception exception){
    String msg = "unknown error occurred";
    if(exception is DioError){
      switch(exception.type){
        case DioErrorType.connectionTimeout:
          msg+="connection time out"; break;
        case DioErrorType.receiveTimeout:
          msg+="server took too long to respond"; break;
        case DioErrorType.sendTimeout:
          msg+="could not send request to server"; break;
        case DioErrorType.badCertificate:
          msg+="invalid token. login again"; break;
        case DioErrorType.connectionError:
          msg = "error while connecting to service"; break;
        case DioErrorType.badResponse:
          if(exception.message?.contains("404") ?? exception.response?.statusCode == 404){
            msg = "invalid request url";
          }else{ msg = "bad response from server"; } break;
        case DioErrorType.unknown:
          print(exception.error);
          if(exception.error.toString().contains("SocketException")){
            msg = "server unreachable!! check your internet";
          }else{ msg = "unknown error"; } break;
        case DioErrorType.cancel:
          msg='request cancelled';
          break;
      }
      return ApiException(msg,statusCode: exception.response?.statusCode);

    }
    return ApiException(msg);
  }

  factory ApiException.fromParsing(Exception exception){
    return ApiException("parsing Exception: "+exception.toString());
  }
}
