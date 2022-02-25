import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/user_connect.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserConnect().actualUser().then((user) {
      if (user != null) Navigator.of(context).popAndPushNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              Text('Entrar', style: Theme.of(context).textTheme.headline4),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: true,
                      validator: (val) {
                        if (val == null) {
                          return 'E-mail obrigatório';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      enableSuggestions: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val == null) {
                          return 'Senha necessária';
                        } else if (!RegExp(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                            .hasMatch(_passwordController.text)) {
                          return 'Senha inválida';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/forgot_password');
                            },
                            child: const Text('Esqueceu a senha?')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      label: const Text('Login'),
                      icon: const Icon(Icons.login),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          UserConnect()
                              .connectUser(_emailController.text.trim(),
                                  _passwordController.text.trim())
                              .then((value) {
                            if (value == null) {
                              Navigator.of(context).popAndPushNamed('/');
                              return null;
                            }
                            var snackbar = SnackBar(
                                content: Text(value),
                                behavior: SnackBarBehavior.floating);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ou',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/signup'),
                      label: const Text('Cadastrar-se'),
                      icon: const Icon(Icons.person_add),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
