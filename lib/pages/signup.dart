import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/user_connect.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro'),
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
                        labelText: 'Nome',
                        icon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      enableSuggestions: true,
                      autocorrect: true,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: true,
                      enableSuggestions: true,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        } else if (!RegExp(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                            .hasMatch(value)) {
                          return 'A senha deve conter no mínimo 8 caracteres, 1 letra maiúscula, 1 letra minúscula, 1 número e 1 caractere especial';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Senha',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        } else if (value != _passwordController.text) {
                          return 'Senhas não conferem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Seu salário',
                        icon: Icon(Icons.monetization_on),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'pt_BR', symbol: 'R\$'),
                      ],
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Valor é obrigatório';
                        }
                        return null;
                      },
                      onSaved: (val) => _amount = double.parse(val!
                          .replaceAll("R\$", '')
                          .replaceAll(".", "")
                          .replaceAll(",", ".")),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          UserConnect()
                              .registerUser(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _nameController.text.trim(),
                                  _amount.toString())
                              .then((value) {
                            if (value == null) {
                              Navigator.of(context).popAndPushNamed('/');
                            }
                            var snackbar = SnackBar(
                              content: Text(value ?? 'Erro ao cadastrar'),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          });
                        }
                      },
                      child: const Text('Cadastrar'),
                    ),
                  ]),
                )
              ]),
            ),
          ),
        ));
  }
}
