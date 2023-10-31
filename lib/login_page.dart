import 'package:app_glpi/auth_form.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset('assets/imagens/logo-glpi.png'),
                    ),
                    const Text(
                      'Sistema de Chamados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color.fromRGBO(129, 129, 129, 1),
                        shadows: [
                          Shadow(
                            offset: Offset(0.00, 3.00),
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: const AuthForm()),
            ],
          ),
        ),
      ),
    );
  }
}
