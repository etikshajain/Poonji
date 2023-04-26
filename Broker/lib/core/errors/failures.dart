

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;

  const Failure(this.message);
}


class ApiFailure extends Failure{
  ApiFailure(super.message);

  @override
  List<Object?> get props => [message];

}


class NoParam extends Equatable{
  @override
  List<Object?> get props => [];
}
