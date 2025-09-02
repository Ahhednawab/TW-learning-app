import 'package:flutter/material.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

Widget customNotificationTile({ 
    required index,
    required String subtitle,
    required String duration
    }) 
 {
 return ListTile(
                leading: Icon(Icons.notifications, color: primaryColor),
                title: Text(
                  index.toString(),
                  style:  TextStyle(fontSize: 12, color: blackColor),
                ),
                subtitle: Text(
                  subtitle,
                  style:  TextStyle(
                    fontSize: 10,
                    color: greyColor,
                  ),
                ),
                trailing:   Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(duration,style: TextStyle(color: greyColor),),
                  ],
                ),
              );}