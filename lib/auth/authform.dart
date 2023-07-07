import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startAuthentication() {
    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity == true) {
      _formKey.currentState?.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential? authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = authResult.user?.uid ?? '';
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/todo icon.png'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value?.isEmpty ??
                          true || !(value?.contains('@') ?? false)) {
                        return 'Incorrect email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                      fillColor: Colors
                          .purple, // Set the text box background color to purple
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Incorrect password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Enter password",
                      labelStyle: GoogleFonts.roboto(),
                      fillColor: Colors
                          .purple, // Set the text box background color to purple
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Incorrect username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value ?? '';
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(),
                        ),
                        labelText: "Enter username",
                        labelStyle: GoogleFonts.roboto(),
                        fillColor: Colors
                            .purple, // Set the text box background color to purple
                        filled: true,
                      ),
                    ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 70,
                    width: double.infinity,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          startAuthentication();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: isLoginPage
                            ? Text(
                                'Login',
                                style: GoogleFonts.roboto(fontSize: 16),
                              )
                            : Text(
                                'SignUp',
                                style: GoogleFonts.roboto(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text(
                              'Not a member?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.purple),
                            )
                          : Text(
                              'Already a member?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.purple),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
