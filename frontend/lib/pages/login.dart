import 'package:flutter/material.dart';
import 'package:frontend/components/Color/theme.dart';
import 'package:frontend/components/EntryForm/circle_logo.dart';
import 'package:frontend/components/EntryForm/entry_button.dart';
import 'package:frontend/components/EntryForm/entry_textfield.dart';
import 'package:iconify_flutter/icons/bxs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Controllers for handling user input in the text fields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  /// Method to handle user login logic
  void signUserIn() {
    // Placeholder for sign-in logic
    // TODO: Add authentication implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.mainBackground, // background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Spacer

              // Username input field
              EntryTextField(
                controller: usernameController,
                label: 'ชื่อบัญชี',
                hintText: 'ชื่อบัญชี',
                obscureText: false,
                icon: Bxs.user,
              ),

              const SizedBox(height: 20), // Spacer

              // Password input field
              EntryTextField(
                controller: passwordController,
                label: 'รหัสผ่าน',
                hintText: 'รหัสผ่าน',
                obscureText: true,
                icon: Bxs.lock,
              ),

              const SizedBox(height: 19), // Spacer

              // link for "ลืมรหัสผ่าน?" 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ลืมรหัสผ่าน?',
                      style: TextStyle(
                        color: MainTheme.mainText,
                        fontSize: 16,
                        fontFamily: 'BaiJamjuree',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 37), // Spacer

              // Sign-in button
              EntryButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 13), // Spacer

              // divider for "หรือ เข้าสู่ระบบผ่าน"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'หรือ เข้าสู่ระบบผ่าน',
                        style: TextStyle(
                          color: MainTheme.mainText,
                          fontSize: 12,
                          fontFamily: 'BaiJamjuree',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 17), // Spacer

              // sign-in buttons for Google & Facebook
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google sign-in button
                  SquareTile(imagePath: 'assets/icon/Google.png'),

                  SizedBox(width: 18), // Spacer

                  // Facebook sign-in button
                  SquareTile(imagePath: 'assets/icon/Facebook.png'),
                ],
              ),

              const SizedBox(height: 150), // Spacer

              // แยก "หากยังไม่มีบัญชี" และ "สมัครสมาชิก" เพื่อมารวมกัน
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'หากยังไม่มีบัญชี,',
                    style: TextStyle(
                      color: MainTheme.mainText,
                      fontSize: 16,
                      fontFamily: 'BaiJamjuree',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(width: 4), // Spacer

                  // hyperLinked for สมัครสมาชิก
                  Text(
                    'สมัครสมาชิก',
                    style: TextStyle(
                      color: MainTheme.hyperlinkedText,
                      fontSize: 16,
                      fontFamily: 'BaiJamjuree',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
