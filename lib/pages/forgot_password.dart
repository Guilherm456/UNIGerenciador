import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/user_connect.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Esqueci a senha"),
        ),
        body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(
                      'Cadastro',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 16),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            autocorrect: true,
                            enableSuggestions: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'E-mail inválido';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(_emailController.text)) {
                                return 'E-mail inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Navigator.of(context).pop();
                                UserConnect()
                                    .recoverUser(_emailController.text);

                                const snackbar = SnackBar(
                                  content: Text('Verifique seu e-mail!'),
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                                setState(() {
                                  _emailController.clear();
                                });
                              }
                            },
                            child: const Text('Enviar'),
                          ),
                        ]))
                  ]))),
        ));
  }
}
