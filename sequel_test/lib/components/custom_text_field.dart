import 'package:flutter/material.dart';
import 'package:sequel_test/config/customTheme.dart';

class CustomTextField extends StatelessWidget {
 CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
   this.onChanged,
   this.obscureText = false,
  });
    final controller;
    bool  obscureText;
    final String hintText;
    final suffixIcon;
    final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.all(1),
      
      decoration: BoxDecoration(
        
          color: CustomColor().appGrey100,
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(

          focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
              width: 0.5,
              color: CustomColor().lightBlue
             ),
            borderRadius: BorderRadius.circular(10),
            
          ),
          
          suffixIcon: suffixIcon,
          hintText: hintText,
          filled: true,
          fillColor: CustomColor().appGrey100,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
