import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.0,
        height: 40.0,
        margin: EdgeInsets.only(right: 16, left: 8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
                //  fit: BoxFit.fill,
                image: new AssetImage('assets/images/avatar.png'))));
  }
}
