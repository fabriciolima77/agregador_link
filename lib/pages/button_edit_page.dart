import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projetos/custom_widgets/custom_simple_button.dart';
import 'package:projetos/custom_widgets/custom_text_field.dart';

class ButtonEditPage extends StatefulWidget {
  const ButtonEditPage({
    required this.title,
    required this.url,
    required this.image,
    required this.id,
    super.key,});

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
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: Text('Editar ${widget.title.toString()}',style: const TextStyle(color: Colors.white),),
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
                  controller: controllerURL,
                  hintText: widget.url,
                  keyBoardType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 32),
                CriaBotaoSimples(
                  hintText: 'Salvar',
                  onPressed: () async {
                    final docUser = FirebaseFirestore.instance
                        .collection('button')
                        .doc(widget.id);

                    docUser.update({
                      'title': controllerTitle.text,
                      'url': controllerURL.text,
                      'id': widget.id,
                      'image': pickedFile!.name,
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

  InputDecoration decoration (String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  );

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
      final ref = FirebaseStorage.instance.ref().child('images/${controllerTitle.text}-$fileName');
      uploadTask = ref.putData(fileBytes!);

    }
  }

  Future deleteOldFile() async {
    final ref = FirebaseStorage.instance.ref().child('images/${widget.title}-${widget.image}');
    await ref.delete();
  }
}