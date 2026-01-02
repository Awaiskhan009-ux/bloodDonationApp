import 'package:blood_application/customs_button.dart';
import 'package:flutter/material.dart';

class HomeCustomButton extends StatelessWidget {
  const HomeCustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("custom button demo"),),
      body: Column(children: [
        CustomButton(title: "Login", onTap: (){
          print("Login Button Clicked ");
        }),
        SizedBox(height: 20,),
        CustomButton(title: "SignUp", onTap: (){
          print("signUp Button Clicked ");
        })
      ],),
    );
  }
}