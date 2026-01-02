import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{

  final  String  title;
  final VoidCallback onTap;

  const CustomButton({
          super.key,
          required this.title,
          required this.onTap,
  });

  @override 
  Widget build(BuildContext context){
    return GestureDetector(
 

      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),


        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


  
    );
  }



}