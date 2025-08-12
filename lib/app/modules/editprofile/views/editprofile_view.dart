import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import 'package:mandarinapp/app/widgets/EditProfileSection.dart';
import '../controllers/editprofile_controller.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Stack(
                
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Handle edit avatar action
                      },
                      child: Icon(Icons.edit_square, size: 16, color: greyColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EditableInfoSection(
              label: 'Name',
              value: 'John Steve',
              textColor: blackColor,
              onEdit: () {
                // Handle edit name action
              },
            ),
            const SizedBox(height: 16),
            EditableInfoSection(
              label: 'Email',
              value: 'johnsteve@yahoo.com',
              textColor: blackColor,
              onEdit: () {
                // Handle edit email action
              },
            ),
            const SizedBox(height: 16),
            EditableInfoSection(
              label: 'Age',
              value: '25 years',
              textColor: blackColor,
              onEdit: () {
                // Handle edit age action
              },
            ),
            const SizedBox(height: 16),
            EditableInfoSection(
              label: 'Gender',
              value: 'Male',
              textColor: blackColor,
              onEdit: () {},
            ),
          ],
        ),
      ),
    );
  }
}
