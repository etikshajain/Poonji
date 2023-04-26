

import 'package:broker/core/api/api_response.dart';
import 'package:broker/core/api/api_service.dart';
import 'package:broker/core/api/endpoints.dart';
import 'package:broker/core/errors/failures.dart';
import 'package:broker/models/entities/loan.dart';
import 'package:dartz/dartz.dart';

class BrokeService{
  final IApiService service;
  const BrokeService(this.service);

  Future<Either<Failure,List<LoanDto>>> getLoans({String? status, String? borrowerId, String? lenderId})async{
    try{
      final res = await service.getCollection<LoanDto>(endpoint: Endpoints.getLoans,queryParameters: {"status":status,"borrower": borrowerId,"lender":lenderId}, converter:LoanDto.fromJson);
      print(res.length);
      return Right(res);
    }on ApiException catch(e){
      return Left(ApiFailure(e.message));
    }catch(e){
      return Left(ApiFailure(e.toString()));
    }
  }
  Future<Either<Failure,LoanDto>> requestLoan(int amount)async{
    try{
      final res = await service.post<LoanDto>(endpoint: Endpoints.requestLoan,data: {"amount":amount}, converter:LoanDto.fromJson);
      return Right(res);
    }on ApiException catch(e){
      return Left(ApiFailure(e.message));
    }catch(e){
      return Left(ApiFailure(e.toString()));
    }
  }
  Future<Either<Failure,LoanDto>> loanAction(String endpoint,String loanId)async{
    try{
      final res = await service.post<LoanDto>(endpoint: endpoint,data: {"loan_id":loanId}, converter:LoanDto.fromJson);
      return Right(res);
    }on ApiException catch(e){
      return Left(ApiFailure(e.message));
    }catch(e){
      return Left(ApiFailure(e.toString()));
    }
  }

}
