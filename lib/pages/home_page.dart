import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_button.dart';
import 'package:projetos/custom_widgets/custom_profile.dart';
import 'package:projetos/pages/auth_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/model_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    var larguraResponsiva = larguraTela < 800 ?
    larguraTela * 0.9 :
    larguraTela < 1024 ?
    larguraTela * 0.5 : larguraTela * 0.4;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
            child: Image.asset('images/linkrapido_logo.png', height: 90, fit: BoxFit.scaleDown,),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings, size: 40),
                color: Colors.white,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()))
            ),
          ],
        ),
        body: StreamBuilder(
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
                      const CustomProfile(),
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
            })
    );
  }

  Widget buildButton(Button button) => SizedBox(
    height: 85,
    child: ListTile(
        contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
        title: CriaBotao(
          hintText: button.title,
          onPressed: () async {
            String url = button.url;
            if (url.isNotEmpty) {
              url = 'http://${Uri.encodeFull(url).replaceAll('https://', '').replaceAll('http://', '')}';
            }
            if (await launchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Não foi possivel iniciar $url';
            }
          },
          left: 10, top: 20, right: 10, bottom: 20,
          src: 'https://firebasestorage.googleapis.com/v0/b/dlsublimarte-linkrapido.appspot.com/o/images%2F${button.title}-${button.image}?alt=media',
        )
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