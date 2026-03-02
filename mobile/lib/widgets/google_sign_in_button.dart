import 'package:flutter/material.dart';
import 'web_auth_stub.dart'
    if (dart.library.js_util) 'web_auth_web.dart'
    if (dart.library.html) 'web_auth_web.dart';

Widget googleSignInButton({VoidCallback? onPressed}) {
  return buildGoogleSignInButton(onPressed: onPressed);
}
