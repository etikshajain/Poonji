import 'package:broker/locator.dart';
import 'package:broker/models/dto/auth.dart';
import 'package:broker/screens/auth/login_page.dart';
import 'package:broker/screens/broke/dashboard.dart';
import 'package:broker/services/auth_service.dart';
import 'package:broker/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  late AuthService authService;

  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passController;
  late final TextEditingController upiController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    authService = sl<AuthService>();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passController = TextEditingController();
    upiController = TextEditingController();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      usernameFocusNode.requestFocus();
    });
  }

  void signUp()async{
    if(formKey.currentState?.validate() ?? false){
      final name = usernameController.text;
      final email = emailController.text;
      final pass = passController.text;
      final phone = phoneController.text;
      final upi = upiController.text;
      final res = await authService.createUser( CreateUserDto(upiId: upi,phone: phone,name: name,email: email,password: pass));
      res.fold(
              (l) => customSnackBar(context: context, message: l.message, backgroundColor: Colors.red),
              (r)async{
          }
      );

      Navigator.of(context).pop();
      customSnackBar(context: context, message:"created!. login with the new account", backgroundColor: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                GestureDetector(
                  onTap: ()async{
                    context.pop();
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
                Text('Sign up',style: TextStyle(color: Colors.black,fontSize: 30, fontWeight: FontWeight.w600),),
                12.height,
                Text('Name',style: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 14,fontWeight: FontWeight.w500) ),
                4.height,
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      usernameFocusNode.requestFocus();
                      return 'Enter valid name';
                    }
                  },
                  onTapOutside:(event) =>  usernameFocusNode.unfocus(),

                  focusNode: usernameFocusNode,
                  controller: usernameController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  decoration: InputDecoration(
                    hintText: "Your Username",
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),

                  ),
                ),
                12.height,
                Text('Phone',style: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 14,fontWeight: FontWeight.w500) ),
                4.height,
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: phoneController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Your Phone",
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                Text('Email',style: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 14,fontWeight: FontWeight.w500) ),
                4.height,
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      emailFocusNode.requestFocus();
                      return 'enter email';
                    }
                    final emailRegExp =
                    RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
                    emailFocusNode.requestFocus();
                    return emailRegExp.hasMatch(value) ? null : 'enter valid email';
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  controller: emailController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Your Email",
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                Text('Upi Id',style: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 14,fontWeight: FontWeight.w500) ),
                4.height,
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  controller: upiController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Your Upi Id",
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                Text('Password',style: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 14,fontWeight: FontWeight.w500) ),
                4.height,
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  obscureText: true,
                  controller: passController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 14,fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )),
                  ),
                ),
                8.height,
                ElevatedButton(
                    onPressed: signUp,
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
                    child: Text('Sign up', style: TextStyle(color:Color(0xFFFCFCFA),fontWeight: FontWeight.w500, fontSize: 16,),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
