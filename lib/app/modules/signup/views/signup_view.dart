import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart' as AppColors;
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/widgets/CustomTextField.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(child: Image.asset('assets/images/splash1.png', height: 160, width: 160, fit: BoxFit.cover,)),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Let’s sign up to your account and start your learning journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.greyColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      customTextField(
                        label: 'Name',
                        controller: controller.nameController,
                        keyT: TextInputType.name,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.emailController,
                        validator: (p0) {
                          if (p0 == null || p0.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (p0.trim().isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(p0.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.5),
                              width: 0.5,
                            ),
                          ),
                          // suffixIcon: Container(
                          //   width: 120,
                          //   alignment: Alignment.centerRight,
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   child: Text(
                          //     '@yopmail.com',
                          //     style: TextStyle(color: Colors.grey),
                          //   ),
                          // ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      // const SizedBox(height: 20),
                      // customTextField(
                      //   label: 'Phone',
                      //   controller: controller.phoneController,
                      //   keyT: TextInputType.phone,
                      // ),
                      const SizedBox(height: 20),
                      Obx(
                        () => customTextField(
                          label: 'Password',
                          controller: controller.passwordController,
                          obscureText: !controller.obscureText.value,
                          icon:
                              controller.obscureText.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onTap: () {
                            controller.toggleObscureText();
                          },
                        ),
                      ),

                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                controller.loader.value
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        controller
                                            .createUserWithEmailAndPassword();
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: Size(double.infinity, 50),
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                            ),
                            child:
                                controller.loader.value
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}