import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  final usernameCtrl = TextEditingController();
  final prefs = SharedPreferencesAsync();

  void fetchPrefs() async {
    // var username = await prefs.getString('username');
    prefs.getString('username').then((value) {
      usernameCtrl.text = value ?? '';
      isChecked = value != null;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.network(
            'https://upload.wikimedia.org/wikipedia/en/7/75/Pangasinan_State_University_logo.png'),
        TextField(
          controller: usernameCtrl,
        ),
        TextField(),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                isChecked = value ?? false;
                setState(() {});
              },
            ),
            const Text('Remember me'),
          ],
        ),

        // Checkbox.adaptive(value: value, onChanged: onChanged)
        ElevatedButton(
          onPressed: doLogin,
          child: const Text('Login'),
        ),
      ],
    ));
  }

  void doLogin() async {
    if (isChecked) {
      //save
      await prefs.setString('username', usernameCtrl.text);
      print('saved');
    } else {
      await prefs.remove('username');
    }
  }
}
