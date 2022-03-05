import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String validValue = 'Ok';

  String? userUid;

  late final userEmail;




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('SignUp Page')),
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue,
          titleSpacing: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          )),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'username'),
              controller: usernameController,
              validator: (value) {
                if (value!.contains('') && value.length >= 4) {
                  return null;
                }
                return 'invalid username';
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'phone'),
              controller: phoneController,
              validator: (value) {
                if (value!.length > 10 && value.contains('')) {
                  return null;
                }
                return 'invalid phone';
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              controller: emailController,
              validator: (value) {
                if (value!.contains('@') && value.contains('.com')) {
                  return null;
                }
                return 'invalid email';
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'password'),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'invalid password';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Future<void> signUp() async {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                      print(userCredential.user!.uid);
                      userUid = userCredential.user!.uid;
                      userEmail = userCredential.user!.email;
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      var errorMessage = 'Authentication failed';
                      if (e.code == 'user-not-found') {
                        errorMessage = 'No user found for that email.';
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        errorMessage = 'Wrong password provided for that user.';
                      }
                    }
                  }
                  signUp();


                },
                child: Text('SignUp'))
          ],
        ),
      ),
    );
  }

}
