
import 'package:broker/locator.dart';
import 'package:broker/screens/auth/signup_page.dart';
import 'package:broker/screens/broke/dashboard.dart';
import 'package:broker/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';

void customSnackBar({
  required BuildContext context,required String message,
  required Color backgroundColor, Color textColor = Colors.white,
}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor),),
        backgroundColor: backgroundColor,
      )
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late AuthService authService;
  final formKey  = GlobalKey<FormState>();

  FocusNode phoneFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  late final TextEditingController phoneController;
  late final TextEditingController passController;

  @override
  void initState() {
    authService = sl<AuthService>();
    phoneController = TextEditingController();
    passController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      phoneFocusNode.requestFocus();
    });
  }

  void getOtp()async{
    if(formKey.currentState?.validate() ?? false){
      context.loaderOverlay.show();
      await Future.delayed(Duration(seconds: 1));
      final phone = phoneController.text;
      final res = await authService.loginUser( phone,passController.text);
      context.loaderOverlay.hide();
      res.fold(
              (l) => customSnackBar(context: context, message: l.message, backgroundColor: Colors.red),
              (r) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard(),))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          height: context.height(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                GestureDetector(
                  onTap: (){
                    if(Navigator.canPop(context)){
                      Navigator.of(context).pop();
                    }else{
                      SystemNavigator.pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFF7e7e7e),
                            width: 0.8,
                            strokeAlign: BorderSide.strokeAlignOutside
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black, size: 20,),
                  ),
                ),
                50.height,
                Text('Get Started',style: TextStyle(color: Colors.black,fontSize: 30, fontWeight: FontWeight.w600),),
                4.height,
                Text('Log in',style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14,) ),
                8.height,
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      phoneFocusNode.requestFocus();
                      return 'enter email';
                    }
                    final emailRegExp =
                    RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
                    phoneFocusNode.requestFocus();
                    return emailRegExp.hasMatch(value) ? null : 'enter valid email';
                  },
                  onTapOutside: (event) => phoneFocusNode.unfocus(),
                  controller: phoneController,
                  focusNode: phoneFocusNode,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.emailAddress,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(color: Color(0xFFb8b8b8,),fontSize: 14,),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    prefixIcon: Container(
                        width: 44,
                        alignment: AlignmentDirectional.center,
                        child: Icon(Icons.email_outlined,size: 18,)),
                    contentPadding: EdgeInsets.only(left: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                20.height,
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      phoneFocusNode.requestFocus();
                      return 'enter password';
                    }
                    if(value.length<4){
                      phoneFocusNode.requestFocus();
                      return 'password too short ';
                    }
                    return null;
                  },
                  onTapOutside: (event) => passFocusNode.unfocus(),
                  controller: passController,
                  focusNode: passFocusNode,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(color: Color(0xFFb8b8b8,),fontSize: 14,),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    prefixIcon: Container(
                        width: 44,
                        alignment: AlignmentDirectional.center,
                        child: Icon(Icons.key,size: 18,),),
                    contentPadding: EdgeInsets.only(left: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                Spacer(),
                /// todo - implement the onPress here
                RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                        style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14),
                        children: [
                          TextSpan(text: 'Don\'t have an Account? '),
                          TextSpan(text: 'Signup',style: TextStyle(decoration: TextDecoration.underline, color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()..onTap = (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen(),));
                              }
                          ),
                        ]
                    )
                ),
                12.height,
                ElevatedButton(
                    onPressed: getOtp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none
                      ),
                      backgroundColor: Colors.black,
                      elevation: 0,
                      fixedSize: Size(context.width(), 48),
                      alignment: AlignmentDirectional.center,
                    ),
                    child: Text('Continue', style: TextStyle(color:Color(0xFFFCFCFA),fontWeight: FontWeight.w500, fontSize: 16,),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
