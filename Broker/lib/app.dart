import 'package:broker/locator.dart';
import 'package:broker/screens/auth/login_page.dart';
import 'package:broker/screens/broke/bloc.dart';
import 'package:broker/screens/broke/dashboard.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class BrokerApp extends StatefulWidget {
  const BrokerApp({Key? key}) : super(key: key);

  @override
  State<BrokerApp> createState() => _BrokerAppState();
}

class _BrokerAppState extends State<BrokerApp> {
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
          child: CupertinoActivityIndicator(color: Colors.black,radius: 14,)
      ),
      overlayOpacity: 0.2,
      duration: Duration(seconds: 1),
      child: MaterialApp(
          theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          home: Provider.of<UserProvider>(context,listen: true).isLoggedIn ? Dashboard() : LoginScreen()
      ),
    );
  }
}
