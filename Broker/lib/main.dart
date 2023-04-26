import 'package:broker/locator.dart';
import 'package:broker/screens/broke/bloc.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'locator.dart' as di;

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(

      ChangeNotifierProvider(
        create: (context) => UserProvider(sl()),
        child: BlocProvider(
        create:(context) => DashboardBloc(sl()),
        child: BrokerApp()),
      ));

}
