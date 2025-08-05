import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthOtpTermsTextWidget extends StatelessWidget {
  final void Function()? onTermsTap;
  final void Function()? onPrivacyTap;
  final void Function()? onCookiesTap;

  const AuthOtpTermsTextWidget({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onCookiesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff80807F),
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'By continuing you accept our '),
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTermsTap,
            ),
            const TextSpan(text: '.\nAlso learn how we process your data in our\n'),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Cookies policy.',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onCookiesTap,
            ),
          ],
        ),
      ),
    );
  }
}
