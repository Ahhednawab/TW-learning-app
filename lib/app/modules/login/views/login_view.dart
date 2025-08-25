import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart' as AppColors;
import 'package:mandarinapp/app/routes/app_pages.dart';
import 'package:mandarinapp/app/widgets/CustomTextField.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
                      Center(child: Image.asset('assets/images/splash1.png', height: 220,fit: BoxFit.cover,)),
                      const SizedBox(height: 50),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Let’s sign in to your account and start your calorie management',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.greyColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      customTextField(
                        label: 'Email',
                        controller: controller.emailController,
                        keyT: TextInputType.emailAddress,
                        validator: (p0) {
                          if (p0 == null || p0.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (p0.trim().isEmpty ||
                              !RegExp(
                                r'^[^@]+@[^@]+\.[^@]+$',
                              ).hasMatch(p0.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => customTextField(
                          label: 'Password',
                          controller: controller.passwordController,
                          obscureText: controller.obscureText.value,
                          icon:
                              controller.obscureText.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onTap: () {
                            controller.toggleObscureText();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: const Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(color: AppColors.secondary),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                controller.loader.value
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.signInWithEmailAndPassword();
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
                                      'Sign In',
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
                          const Text('Don’t have an account?'),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.SIGNUP);
                            },
                            child:  Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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