

import 'package:bloc/bloc.dart';
import 'base_enums.dart';
import 'base_state.dart';

/// A cubit to implement business logic over a data [T]
/// The Data is Stored inside the [CubitState]
/// All cubits would have their own functionality equivalent to the events
/// but instead of just single [emit] function, [BaseCubit] provides separate methods
/// to emit different essential states
abstract class BaseCubit<T> extends Cubit<CubitState<T>>{
  BaseCubit(super.initialState);

  setData(T data){
    emit(state.copyWith(data: data, isLoading: false, message: null));
  }

  /// sets the new data with the message that would be listened to set the toast
  setDataWithMessage(T data, {required String message, required MessageType type}){
    assert(type != MessageType.error || (throw 'invalid use of method to set error, data can not be set with the error. check setError method instead'));
    emit(state.copyWith(data: data, isLoading: false, message: Message(value: message, type: type, showType: ShowType.toast)));
  }

  /// this emits the CubitState with [isLoading] = true
  /// The previous stored data is preserved
  setLoading(){
    emit(state.copyWith(isLoading:true, message:  null));
  }

  /// this message would work based on the [ShowType] provided in the [MessageType]
  /// by default it is to auto captured and show toast
  setMessage(String message,{required MessageType type}){
    emit(state.copyWith(isLoading: false, message: Message(value: message, type: type, showType: ShowType.toast)));
  }

  setError(String error,{required ShowType show}){
    emit(state.copyWith(isLoading: false, message: Message(value: error, type: MessageType.error, showType: show)));
  }



}
