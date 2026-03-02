import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

Widget buildGoogleSignInButton({VoidCallback? onPressed}) {
  final plugin = GoogleSignInPlatform.instance;
  if (plugin is GoogleSignInPlugin) {
     return web.renderButton();
  }
  return const Center(child: Text('Plugin Not Ready'));
}
