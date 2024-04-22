import 'package:flutter/material.dart';

class AppBarRow extends StatelessWidget {
  const AppBarRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon( 
          Icons.circle_outlined,color: kDefaultIconLightColor
        ),
        Text(
          'My Spending',
          style: TextStyle(color: kDefaultIconLightColor, fontSize: 20.0),
        ),
        Icon(
          Icons.calendar_today,color: kDefaultIconLightColor
        ),
      ],
    );
  }
}