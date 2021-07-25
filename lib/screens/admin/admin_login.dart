import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/admin/admin_panel.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/shared/custom_widget_border.dart';

void _showToast(BuildContext context, {required String text}) {
  late FToast fToast;
  fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey[850],
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.7),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_rounded, color: Colors.red[700]),
        const SizedBox(
          width: 12.0,
        ),
        Text(text.toString(), style: const TextStyle(color: Colors.white)),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 6),
  );
}

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'form key');
  final _emailFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  String email = '';
  String password = '';

  @override
  void initState() {
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Admin Portal',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      onChanged: (val) => email = val,
                      decoration: InputDecoration(
                        hintText: 'example@ais.ae',
                        labelText: 'email',
                        labelStyle: TextStyle(
                          color: _emailFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 15, 8, 20),
                        border:
                            CustomWidgetBorder(color: Colors.grey, width: 1.2),
                        enabledBorder:
                            CustomWidgetBorder(color: Colors.grey, width: 1.2),
                        errorBorder: CustomWidgetBorder(
                            color: Colors.red[300], width: 1.5),
                        focusedErrorBorder: CustomWidgetBorder(
                            color: Colors.red[300], width: 2.4),
                        errorStyle: const TextStyle(fontSize: 14),
                        focusedBorder:
                            CustomWidgetBorder(color: Colors.blue, width: 2.2),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: _emailFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: _emailFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            _emailController.clear();
                            email = '';
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      onChanged: (val) => password = val,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'password',
                        labelStyle: TextStyle(
                          color: _passwordFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 15, 8, 20),
                        border:
                            CustomWidgetBorder(color: Colors.grey, width: 1.2),
                        enabledBorder:
                            CustomWidgetBorder(color: Colors.grey, width: 1.2),
                        errorBorder: CustomWidgetBorder(
                            color: Colors.red[300], width: 1.5),
                        focusedErrorBorder: CustomWidgetBorder(
                            color: Colors.red[300], width: 2.4),
                        errorStyle: const TextStyle(fontSize: 14),
                        focusedBorder:
                            CustomWidgetBorder(color: Colors.blue, width: 2.2),
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: _passwordFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: _passwordFocusNode.hasFocus
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: _passwordFocusNode.hasFocus
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                _passwordController.clear();
                                password = '';
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Go Back'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () async {
                      AuthService _auth = AuthService();
                      dynamic result =
                          await _auth.logIn(email: email, password: password);
                      if (result is User) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AdminPanel()));
                      } else {
                        _showToast(context,
                            text: _auth.getError(result.toString()));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
