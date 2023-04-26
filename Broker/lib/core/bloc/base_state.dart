import 'package:equatable/equatable.dart';
import 'base_enums.dart';


class Message extends Equatable{
  final MessageType type;
  final String value;
  final ShowType showType;

  Message({required this.value, this.type = MessageType.info, this.showType = ShowType.none});

  @override
  List<Object?> get props => [type, value];
}

class CubitState<T> extends Equatable{
  final T data;
  final bool isLoading;
  final Message? message;

  CubitState({required this.data, required this.isLoading, this.message});

  CubitState<T> copyWith({
    T? data, bool? isLoading, Message? message
  }){
    return CubitState(data: data?? this.data, isLoading: isLoading ?? this.isLoading , message: message);
  }

  @override
  List<Object?> get props => [data, isLoading, message];

}
