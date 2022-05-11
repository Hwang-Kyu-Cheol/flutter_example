import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatting/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../add_image/add_image.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  bool isSignupScreen = true;
  bool showSpinner = false;

  final _signUpFormKey = GlobalKey<FormState>();
  final _logInFormKey = GlobalKey<FormState>();

  String signUpUserName = '';
  String signUpUserEmail = '';
  String signUpUserPassword = '';
  String logInUserEmail = '';
  String logInUserPassword = '';
  String? userPickedImage;

  void pickedImage(String image){
    userPickedImage = image;
  }

  bool _isValidate(){

    dynamic formKey = isSignupScreen? _signUpFormKey : _logInFormKey;

    final isValid = formKey.currentState!.validate();

    if(isValid) {
      formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  void showAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(pickedImage),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              //배경
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/red.jpg'),
                      fit: BoxFit.fill
                    )
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white
                            ),
                            children: [
                              TextSpan(
                                text: isSignupScreen? ' to Yummy chat!' : ' back!',
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          isSignupScreen? 'Signup to continue' : 'Signin to continue',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //텍트스 폼 필드
              Positioned(
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width-40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5
                      )
                    ]
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen? Palette.activeColor : Palette.textColor1
                                    ),
                                  ),
                                  if(!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'SIGNUP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignupScreen? Palette.activeColor : Palette.textColor1
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      if(isSignupScreen)
                                      GestureDetector(
                                        onTap: (){
                                          showAlert(context);
                                        },
                                        child: Icon(
                                          Icons.image,
                                          color: isSignupScreen ? Colors.cyan : Colors.grey[300],
                                        ),
                                      )
                                    ],
                                  ),
                                  if(isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,3,35,0),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        if(isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(1),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 4){
                                      return '사용자 이름을 4글자 이상 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    signUpUserName = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0))
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0))
                                    ),
                                    hintText: 'User name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  key: ValueKey(2),
                                  validator: (value){
                                    if(value!.isEmpty || !value.contains('@')){
                                      return '유효한 이메일을 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    signUpUserEmail = value!;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  key: ValueKey(3),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 6){
                                      return '비밀번호를 6글자 이상 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    signUpUserPassword = value!;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if(!isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _logInFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(4),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return '이메일을 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    logInUserEmail = value!;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  key: ValueKey(5),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return '비밀번호를 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    logInUserPassword = value!;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //전송 버튼
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen? 430 : 390,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: GestureDetector(
                      onTap: () async{
                        setState(() {
                          showSpinner = true;
                        });
                        if(_isValidate()){
                          if(isSignupScreen){
                            if(userPickedImage == null){
                              setState(() {
                                showSpinner = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please pick your image'),
                                    backgroundColor: Colors.blue,
                                  )
                              );
                              return;
                            }
                            try{
                              final newUser = await _authentication.createUserWithEmailAndPassword(
                                email: signUpUserEmail,
                                password: signUpUserPassword,
                              );

                              // final refImage = FirebaseStorage.instance
                              //     .ref()
                              //     .child('picked_image')
                              //     .child(newUser.user!.uid + '.png');
                              //
                              // await refImage.putFile(userPickedImage!);
                              // final url = await refImage.getDownloadURL();

                              await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                              .set({
                                'userName' : signUpUserName,
                                'email' : signUpUserEmail,
                                'picked_image' : userPickedImage,
                              });

                              if(newUser.user != null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('회원가입이 정상적으로 처리되었습니다.'),
                                    backgroundColor: Colors.blue,
                                  )
                                );
                                setState(() {
                                  isSignupScreen = false;
                                });
                              }
                            }catch(e){
                              print(e);
                            }
                          } else {
                            try{
                              final user = await _authentication.signInWithEmailAndPassword(
                                email: logInUserEmail,
                                password: logInUserPassword,
                              );
                            }catch(e){
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('아이디와 비밀번호를 확인하세요.'),
                                    backgroundColor: Colors.blue,
                                  )
                              );
                            }
                          }
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.red
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0,1)
                            )
                          ]
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ),
                    )
                  ),
                ),
              ),

              //구글 로그인 버튼
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen? MediaQuery.of(context).size.height - 125 : MediaQuery.of(context).size.height - 165,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(isSignupScreen? 'or Signup with' : 'or Signin with'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: (){},
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        backgroundColor: Palette.googleColor,
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Google'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
