// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:worksample/widgets/background.dart';
import 'package:worksample/widgets/button.dart';
import 'package:worksample/widgets/customTextField.dart';
import 'package:worksample/widgets/loader.dart';
import 'package:worksample/widgets/logo.dart';
import 'package:worksample/widgets/resDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController derivController = TextEditingController();
  String login = '';
  String pwd = '';
  String deriv = '';
  String res = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);
    return Scaffold(
        body: SingleChildScrollView(
      child: BackgroundImageContainer(
          imageUrl:
              //https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-7brhZmwXn08-unsplash.jpg?alt=media&token=ea7ee065-0bb3-4184-8baf-9188d268f075
              'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/finance_app_2%2Fbackground1.png?alt=media&token=c54b7fd8-c4a6-4192-82a6-08335e7fcea5',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Logo(),
                        ),
                        CustomInput(
                          'Login',
                          'Alphanumeric value',
                          validator: Validators.compose([
                            Validators.required('Login is required'),
                            Validators.patternString(r"^[A-Za-z0-9]+$",
                                'This should be an alphanumerics value'),
                          ]),
                          inputController: loginController,
                        ),
                        CustomInput(
                          'Password',
                          '',
                          inputController: pwdController,
                          obscureText: true,
                          validator: Validators.compose([
                            Validators.required('Password is required'),
                          ]),
                        ),
                        CustomInput(
                          'Polynomial',
                          'Enter polynomial',
                          inputController: derivController,
                          validator: Validators.compose([
                            Validators.required('Polynominal required'),
                          ]),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: double.infinity,
                          child: GradientButton(
                              text: loading == false
                                  ? Text(
                                      'Login',
                                      style: const TextStyle(
                                          color: accentColor, fontSize: 16),
                                    )
                                  : DottedCircularProgressIndicatorFb(
                                      currentDotColor: secondaryColor,
                                      defaultDotColor: accentColor,
                                      numDots: 7),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  login = loginController.text;
                                  pwd = pwdController.text;
                                  deriv = derivController.text;
                                  res =
                                      calculateDerivative(derivController.text);
                                  FirebaseFirestore.instance
                                      .collection('users') //saving to firestore
                                      .doc()
                                      .set({
                                    'login': login,
                                    'password': pwd,
                                    'polynomial': deriv,
                                    'result': res,
                                  }).then((respuesta) {
                                    setState(() {
                                      loading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ResDialog(res));
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    ));
  }

  //get polynomial derivative
  String calculateDerivative(input) {
    var finalRes = '';
    for (int i = 0; i < input.length; i++) {
      //2x^2+3x^1+4
      //loop through the input
      var char = input[i];
      if (char == '^') {
        //if char is ^
        var position = input[i + 1];
        var rValue = input[i - 2];
        var xValue = input[i - 1];
        var lead = '';
        try {
          //if there is a leading number
          lead = input[i - 3];
        } catch (e) {
          ///exception
          lead = '';
        }
        if (position == '1' || position == '' || position == ' ') {
          //if position is 1 or empty
          finalRes +=
              (lead + (int.parse(position) * int.parse(rValue)).toString());
        } else {
          //x^n
          finalRes += (lead +
              (int.parse(position) * int.parse(rValue)).toString() +
              xValue +
              '^' +
              (int.parse(position) - 1).toString());
        }
      }
    }

    return finalRes;

    ///return final result
  }
}
