import 'package:flutter/material.dart';
import 'package:sequel_test/config/customTheme.dart';

class customBackButton extends StatelessWidget {
  const customBackButton({
    super.key,
    required this.onTap
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(BorderSide(color: CustomColor().appGrey300))
        ),
        child: Center(child: Icon(Icons.arrow_back_ios_new, size: 14,)),
      ),
    );
  }
}
