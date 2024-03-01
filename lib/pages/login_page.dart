import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_icon_textfield.dart';
import 'package:projetos/custom_widgets/custom_profile.dart';
import 'package:projetos/custom_widgets/custom_simple_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerSenha = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    var larguraResponsiva = larguraTela < 800 ?
    larguraTela * 0.9 :
    larguraTela < 1024 ?
    larguraTela * 0.5 : larguraTela * 0.4;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        title: const Text('Fazer Login',style: TextStyle(color: Colors.white),),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: larguraResponsiva,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomProfile(),
              const SizedBox(height: 34),
              const Text(
                  'Entre com seus dados para acessar o painel de edição',
                style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CampoTextoIcone(
                      obscureText: false,
                      validator: validateEmail(),
                      onChanged: (value) {
                        setState(() {
                          controllerEmail;
                        });
                      },
                      controller: controllerEmail,
                      hintText: 'Digite seu email',
                      preffixWidget: const Icon(Icons.alternate_email_rounded, size: 24),
                    ),
                    const SizedBox(height: 24),
                    CampoTextoIcone(
                      obscureText: _obscureText,
                      validator: validateSenha(),
                      onChanged: (value) {
                        setState(() {
                          controllerSenha;
                        });
                      },
                      controller: controllerSenha,
                      hintText: 'Digite sua senha',
                      preffixWidget: const Icon(Icons.lock_rounded, size: 24),
                      suffixWidget: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CriaBotaoSimples(
                hintText: 'Fazer Login',
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    authLogin();
                  }
                },
                left: 40, top: 20, right: 40, bottom: 20,

              ),
            ],
          ),
        ),
      ),
    );
  }

  void authLogin() async {
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
        );
      },
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerSenha.text,
      );
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException {
      if (context.mounted) Navigator.pop(context);
      credIncorreta();
    }
  }

  void credIncorreta(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Email ou senha incorretos!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        duration: const Duration(milliseconds: 1800),
        behavior: SnackBarBehavior.floating,
        width: 300,
        backgroundColor: Colors.red,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0)
        )
    ));
  }

  String? validateEmail (){
    String validarEmail = controllerEmail.text;
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if(validarEmail.isEmpty){
      return "Favor digite seu email";
    } else if (validarEmail.isNotEmpty && !regex.hasMatch(validarEmail)) {
      return ('Email invalido!');
    }
    return null;
  }

  String? validateSenha (){
    String validarSenha = controllerSenha.text;
    if(validarSenha.isEmpty){
      return "Por favor digite sua senha";
    }
    return null;
  }
}
