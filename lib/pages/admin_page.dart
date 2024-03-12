import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_button.dart';
import 'package:projetos/custom_widgets/custom_profile.dart';
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
  Widget build(BuildContext context) {

    double larguraTela = MediaQuery.of(context).size.width;
    var larguraResponsiva = larguraTela < 800 ?
    larguraTela * 0.9 :
    larguraTela < 1024 ?
    larguraTela * 0.7 : larguraTela * 0.6;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 40),
            color: Colors.white,
            onPressed: logOut,
          ),
        ],
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

              return Center(
                child: Column(
                  children: [
                    const CustomProfile(isVisible: false,),
                    SizedBox(
                      width: larguraResponsiva,
                      child: ListView(
                        shrinkWrap: true,
                        children: buttons.map(buildButton).toList(),
                      ),
                    ),
                  ],
                ),
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
  }

  Widget buildButton(Button button) => ListTile(
      title: CriaBotao(
        hintText: button.title,
        onPressed: () {},
        left: 10, top: 20, right: 10, bottom: 20,
        src: 'https://firebasestorage.googleapis.com/v0/b/dlsublimarte-linkrapido.appspot.com/o/images%2F${button.title}-${button.image}?alt=media',
      ),
    trailing: SizedBox(
      height: 30,
      width: 50,
      child: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
               PopupMenuItem<String>(
                  value: 'option1',
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Editar'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ButtonEditPage(title: button.title, url: button.url, image: button.image, id: button.id,))),
                  )
              ),
              const PopupMenuDivider(),
               PopupMenuItem<String>(
                value: 'option2',
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Excluir'),
                    onTap: () async {
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
                  )
              ),
            ];
          },
      )
    ),
  );

  void logOut () {
     FirebaseAuth.instance.signOut();
    }


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