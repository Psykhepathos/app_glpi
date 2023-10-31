import 'package:app_glpi/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _passwordController = TextEditingController();
  final _loginController = TextEditingController();
  bool _isLoading = false;

  Future<void> showNotification() async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'Local Notifications',
        icon: '@mipmap/ic_launcher', //add app icon here
        importance: Importance.max,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'ATENÇÃO',
      'Um novo chamado foi atribuido para você',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 165, 243, 1),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Login',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(129, 129, 129, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 165, 243, 1),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Senha',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(129, 129, 129, 1),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08,
              child: TextButton(
                onPressed: () async {
                  showNotification();
                  setState(() {
                    _isLoading = true;
                  });

                  userProvider.setLogin(_loginController.text);
                  _loginController.clear();
                  userProvider.setPassword(_passwordController.text);
                  _passwordController.clear();
                  await userProvider.loginUser();

                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pushNamed(context, '/ticket_list');
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: const Color.fromRGBO(0, 165, 243, 1),
                ),
                child: const Text('Login',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
