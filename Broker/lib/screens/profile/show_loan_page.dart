import 'package:broker/core/bloc/base_enums.dart';
import 'package:broker/core/bloc/base_state.dart';
import 'package:broker/models/entities/loan.dart';
import 'package:broker/screens/broke/bloc.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class ShowLoanPage extends StatefulWidget {
  final String title;
  const ShowLoanPage({Key? key,required this.title}) : super(key: key);

  @override
  State<ShowLoanPage> createState() => _ShowLoanPageState();
}

class _ShowLoanPageState extends State<ShowLoanPage> {

  @override
  void initState() {
    if(widget.title == 'Lent Loan'){
      context.read<DashboardBloc>().getDashboardLoans(lent: context.read<UserProvider>().user.id);
    }else{
      context.read<DashboardBloc>().getDashboardLoans(borrow: context.read<UserProvider>().user.id);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
              context.pop();
          },
        ),
        actions: [
        ],
        bottom: PreferredSize(child: Container(color: Colors.grey,height: 1,),preferredSize: Size.fromHeight(3)),
      ),
      body:BlocBuilder<DashboardBloc, CubitState<List<LoanDto>>>(builder: (context, state) {
        if(state.isLoading){
          return Center(
              child: Center(child: CupertinoActivityIndicator(radius: 12,)));
        }else if (state.message!=null && state.message!.showType == ShowType.view){
          return Center(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message!.value),
                    ElevatedButton(onPressed: (){
                      context.read<DashboardBloc>().getDashboardLoans();
                    }, child: Text('retry'))
                  ],
                )
            ),
          );
        }else{
          return buildLoanList(state.data);
        }
      },),
    );
  }

  buildLoanList(List<LoanDto> data){
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 12),
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data[index].borrower.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                  4.height,
                  Text('INR ${data[index].amount}',style: TextStyle(color: Colors.black),),
                ],
              ),
              Spacer(),
              ElevatedButton(onPressed: (){}, child: Text('Send Money'))
            ],
          )
      ),);
  }
}
