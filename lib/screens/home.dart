import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/signuppage.dart';
import 'loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xffFE5F55)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login',
                      style: Theme.of(context)
                          .textTheme.headlineSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Container(
              width: 123,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('SignUp', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff43C59E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}