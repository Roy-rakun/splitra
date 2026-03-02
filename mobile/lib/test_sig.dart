import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  final google = GoogleSignIn.instance;
  final account = await google.authenticate(scopeHint: ['email']);
  
  // Test authentication getter
  final auth = account.authentication;
  final idToken = auth.idToken;

  // Test authorization client for accessToken
  final authz = await account.authorizationClient.authorizeScopes(['email']);
  final accessToken = authz.accessToken;
}
