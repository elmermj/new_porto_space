import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlexibleBar extends StatelessWidget {
  const FlexibleBar({Key? key, required this.username, required this.notifCount}) : super(key: key);
  final String username;
  final int notifCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.only(bottom: 20, left: 36, right: 36, top: kToolbarHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              SizedBox(
                width: Get.width,
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: kDefaultIconLightColor, fontSize: 18),
                ),
              ),
              SizedBox(
                width: Get.width,
                child: Text(
                  username,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: kDefaultIconLightColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Text(
            notifCount>1?'You have $notifCount new notifications':'You have a new notification',
            style: TextStyle(
              color: kDefaultIconLightColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w400
            ),
          )
        ],
      ),
    );
  }
}