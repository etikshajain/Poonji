

import 'package:broker/core/bloc/base_cubit.dart';
import 'package:broker/core/bloc/base_enums.dart';
import 'package:broker/core/bloc/base_state.dart';
import 'package:broker/models/entities/loan.dart';
import 'package:broker/services/broke_service.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends BaseCubit<List<LoanDto>>{
  final BrokeService service;

  DashboardBloc(this.service): super(CubitState(data: [], isLoading: true));

  getDashboardLoans(BuildContext context,{String? status, String? lent, String? borrow})async{
    final loans = await service.getLoans(status: status??'requested',lenderId: lent, borrowerId: borrow);
    loans.fold((l) => setError(l.message, show: ShowType.view,), (r){
      if(borrow!=null){
        setData(r.where((element) => element.borrower.sId == context.read<UserProvider>().user.id).toList());
      }
    });
  }

}
