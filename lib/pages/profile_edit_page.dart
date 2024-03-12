import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_simple_button.dart';
import 'package:projetos/custom_widgets/custom_text_field.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({
    required this.title,
    required this.subtitle,
    required this.profileImage,
    required this.id,
    super.key});

  final String title;
  final String subtitle;
  final String profileImage;
  final String id;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final controllerTitle = TextEditingController();
  final controllerSubtitle = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Editar Perfil}',style: TextStyle(color: Colors.white),),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  if (pickedFile != null)
                    SizedBox(
                        child: Container(
                          height: 400,
                          width: 200,
                          color: Colors.white,
                          child: Center(
                            child: Image.memory(pickedFile!.bytes!, fit: BoxFit.contain,),
                          ),
                        )
                    ),
                  const SizedBox(height: 20),
                  IconButton(
                      onPressed: selectFile,
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                      )
                  ),
                  const SizedBox(height: 40),
                  CampoTexto(
                    controller: controllerTitle,
                    hintText: widget.title,
                    keyBoardType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),
                  CampoTexto(
                    controller: controllerSubtitle,
                    hintText: widget.subtitle,
                    keyBoardType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 32),
                  CriaBotaoSimples(
                    hintText: 'Salvar',
                    onPressed: () async {
                      final docUser = FirebaseFirestore.instance
                          .collection('profile')
                          .doc(widget.id);

                      docUser.update({
                        'title': controllerTitle.text,
                        'subtitle': controllerSubtitle.text,
                        'id': widget.id,
                        'profileImage': pickedFile!.name,
                      });

                      uploadFile();
                      deleteOldFile();

                      Navigator.pop(context);
                    },
                    left: 20, top: 10, right: 20, bottom: 10,

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image
    );
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final result = pickedFile;

    if (result != null) {
      final fileBytes = result.bytes;
      final fileName = result.name;

      // upload file
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      uploadTask = ref.putData(fileBytes!);

    }
  }

  Future deleteOldFile() async {
    final ref = FirebaseStorage.instance.ref().child('images/${widget.profileImage}');
    await ref.delete();
  }
}
