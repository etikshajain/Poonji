import 'package:broker/core/bloc/base_enums.dart';
import 'package:broker/core/bloc/base_state.dart';
import 'package:broker/locator.dart';
import 'package:broker/models/entities/loan.dart';
import 'package:broker/screens/broke/bloc.dart';
import 'package:broker/screens/profile/profile_page.dart';
import 'package:broker/services/broke_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    context.read<DashboardBloc>().getDashboardLoans();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Broker'),
        actions: [
          IconButton(onPressed:(){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(),));

          },icon: Icon(Icons.account_circle_outlined,)),
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
          return buildDashboard(state.data);
        }
      },),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: requestLoan,
        label: Text('Request Loan'),
      ),
    );
  }


  requestLoan()async{
    final res = await showDialog<String?>(context:context  , builder: (context) => AddFolderCard(),);
    if(res == null){
      return;
    }
    final amount = int.parse(res);
    final value = await sl<BrokeService>().requestLoan(amount);
    value.fold(
            (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Failed',style: TextStyle(color: Colors.black),),backgroundColor: Colors.red,)),
            (r){
              final d = [...context.read<DashboardBloc>().state.data];
              d.add(r);
              context.read<DashboardBloc>().setData(d);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Success',style: TextStyle(color: Colors.black),),backgroundColor: Colors.green,));
            });
  }


  buildDashboard(List<LoanDto> data){
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 18),
      primary: true,
      child: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard',style: TextStyle( color: Colors.black,fontSize: 24,fontWeight: FontWeight.w500),),
          10.height,
          if(data.isNotEmpty)
          ListView.builder(
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
            ),),
          if(data.isEmpty)
            Container(height: 500,child: Text('No one requested loan.'),alignment: Alignment.center,)
        ],
      ),
    );
  }
}



class AddFolderCard extends StatefulWidget {
  const AddFolderCard({Key? key,}) : super(key: key);

  @override
  State<AddFolderCard> createState() => _AddFolderCardState();
}

class _AddFolderCardState extends State<AddFolderCard> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
        child: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'enter amount',
          ),
        ),
      ),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500,height: 1.2),
      contentTextStyle: TextStyle(color: Colors.grey, fontSize: 16,fontWeight: FontWeight.w400,height: 1.25),
      contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
      titlePadding: EdgeInsets.only(top: 24,left: 16,right: 16),
      backgroundColor: Colors.white,
      actions:[
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(null),
            style:OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black.withOpacity(0.9),
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              fixedSize: Size(double.infinity, 40),
            ),
            child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 14))),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          style:ElevatedButton.styleFrom(
              backgroundColor:Colors.black,
              fixedSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )

          ),
          child: Text('Request Money',style:TextStyle(color: Colors.white, fontSize: 14) ,), )
      ],
    );

  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
