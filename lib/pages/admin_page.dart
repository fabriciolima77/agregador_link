import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_button.dart';
import 'package:projetos/pages/button_edit_page.dart';

import '../models/model_button.dart';
import 'create_button_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: const Text(
          'Editar LinkRapido',
          style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.transparent,
      leading: const BackButton(
        color: Colors.white,
      ),

    ),
    body: StreamBuilder<List<Button>>(
        stream: readButtons(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro na obtenção de dados :(',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final buttons = snapshot.data!;

            return ListView(
              children: buttons.map(buildButton).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
    floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFDC600),
        foregroundColor: Colors.black,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateButtonPage())),
        child: const Icon(Icons.add)
    ),
  );

  Widget buildButton(Button button) => ListTile(
      title: CriaBotao(
        hintText: button.title,
        onPressed: () {},
        left: 10, top: 20, right: 10, bottom: 20,
        src: 'https://firebasestorage.googleapis.com/v0/b/dlsublimarte-linkrapido.appspot.com/o/images%2F${button.title}-${button.image}?alt=media',
      ),
    trailing: SizedBox(
      height: 30,
      width: 100,
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ButtonEditPage(title: button.title, url: button.url, image: button.image, id: button.id,))),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              final docUser = FirebaseFirestore.instance
                  .collection('button')
                  .doc(button.id);

              docUser.update({
                'isActive': false,
              });

              docUser.delete();
              final ref = FirebaseStorage.instance.ref().child('images/${button.title}-${button.image}');
              await ref.delete();
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    ),
  );


  Stream<List<Button>> readButtons() => FirebaseFirestore.instance
      .collection('button')
      .where('isActive', isEqualTo: true)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Button.fromJson(doc.data())).toList());

  Future<Button?> readButton() async {
    final docButton = FirebaseFirestore.instance.collection('button').doc();
    final snapshot = await docButton.get();
    if (snapshot.exists) {
      return Button.fromJson(snapshot.data()!);
    }
    return null;
  }
}