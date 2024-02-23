import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_simple_button.dart';
import 'package:projetos/custom_widgets/custom_text_field.dart';

class ButtonEditPage extends StatefulWidget {
  const ButtonEditPage({
    required this.title,
    required this.url,
    required this.image,
    required this.id,
    super.key});

  final String title;
  final String url;
  final String image;
  final String id;

  @override
  State<ButtonEditPage> createState() => _ButtonEditPageState();
}

class _ButtonEditPageState extends State<ButtonEditPage> {
  final controllerTitle = TextEditingController();

  final controllerURL = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: Text('Editar ${widget.title.toString()}',style: const TextStyle(color: Colors.white),),
      leading: const BackButton(
        color: Colors.white,
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CampoTexto(
                controller: controllerTitle,
                hintText: widget.title,
              ),
              const SizedBox(height: 24),
              CampoTexto(
                controller: controllerURL,
                hintText: widget.url,
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 32),
              CriaBotaoSimples(
                hintText: 'Salvar',
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('button')
                      .doc(widget.id);

                  docUser.update({
                    'title': controllerTitle.text,
                    'url': controllerURL.text,
                    'id': widget.id,
                  });

                  Navigator.pop(context);
                },
                left: 20, top: 10, right: 20, bottom: 10,

              ),
            ],
          ),
        )
      ],
    ),
  );

  InputDecoration decoration (String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  );
}