

import 'package:broker/core/api/api_response.dart';
import 'package:broker/core/api/api_service.dart';
import 'package:broker/core/api/endpoints.dart';
import 'package:broker/core/errors/failures.dart';
import 'package:broker/locator.dart';
import 'package:broker/models/dto/auth.dart';
import 'package:broker/models/entities/user.dart';
import 'package:dartz/dartz.dart';

class AuthService{
  final IApiService service;
  const AuthService(this.service);

  Future<Either<Failure, NoParam>> createUser(CreateUserDto userDto)async{
      try{
        final res = await service.post(endpoint: Endpoints.createUser, data: userDto.toJson(), converter: (json){

        });
        return Right(NoParam());
      }on ApiException catch(e){
        return Left(ApiFailure(e.message));
      }catch(e){
        return Left(ApiFailure(e.toString()));
      }
  }
  Future<Either<Failure, NoParam>> loginUser(String email ,String password)async{
    try{
      final res = await service.post(endpoint: Endpoints.loginUser, data: {"email":email,"password":password}, converter: (json){
        sl<IApiService>().addToken(json['access_token'].toString());
      });
      return Right(NoParam());
    }on ApiException catch(e){
      return Left(ApiFailure(e.message));
    }on Exception catch(e){
      return Left(ApiFailure(e.toString()));
    }
  }
  Future<Either<Failure, User>> getUser()async{
    try{
      final res = await service.getModelled<User>(endpoint: Endpoints.getUser,  converter:User.fromJson);
      return Right(res);
    }on ApiException catch(e){
      return Left(ApiFailure(e.message));
    }catch(e){
      return Left(ApiFailure(e.toString()));
    }
  }
}
