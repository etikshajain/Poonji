import 'package:broker/locator.dart';
import 'package:broker/models/entities/user.dart';
import 'package:broker/screens/auth/login_page.dart';
import 'package:broker/screens/broke/bloc.dart';
import 'package:broker/screens/profile/show_loan_page.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),
        actions: [
          IconButton(onPressed: ()async{
            await context.read<UserProvider>().setUser(User.empty);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            buildTile('Lent Loan'),
            buildTile('Taken Loan'),
          ],
        ),
      ),
    );
  }


  Widget buildTile(String title){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
            create: (context) => DashboardBloc(sl()),
            child: ShowLoanPage(title: title)),));
      },

      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Text(title),
              Spacer(),
              Icon(Icons.arrow_forward_ios_outlined,size: 18,)
            ],
          )
      ),
    );
  }
}
