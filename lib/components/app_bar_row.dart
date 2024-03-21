import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarRow extends StatelessWidget {
  const AppBarRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
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