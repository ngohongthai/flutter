import 'package:chat_app/app/authentication/auth_screen_viewmodel.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/services/top_level_provider.dart';
import 'package:chat_app/utils/alert_dialogs.dart';
import 'package:chat_app/utils/snackbars.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = ChangeNotifierProvider<AuthenViewModel>(
    (ref) => AuthenViewModel(auth: ref.watch(firebaseAuthProvider)));

class AuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authenViewModel = watch(authViewModelProvider);
    return ProviderListener<AuthenViewModel>(
        provider: authViewModelProvider,
        onChange: (context, model) async {
          if (model.error != null) {
            await showExceptionAlertDialog(
                context: context,
                title: Strings.signInFailed,
                exception: model.error);
          }
        },
        child: AuthScreenContent(viewModel: authenViewModel));
  }
}

class AuthScreenContent extends StatelessWidget {
  final AuthenViewModel viewModel;

  const AuthScreenContent({Key? key, required this.viewModel})
      : super(key: key);

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: _submitAuthForm,
      ),
    );
  }
}

/*
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    UserCredential userCredential;
    if (isLogin) {
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnakBarError(context, 'No user found for that email')
        } else if (e.code == 'wrong-password') {
          showSnakBarError(context, 'Wrong password provided for that user');
        }
      }
    } else {
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnakBarError(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showSnakBarError(context, 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: _submitAuthForm,
      ),
    );
  }
}

*/