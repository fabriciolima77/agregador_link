import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetos/models/model_profile.dart';

import '../pages/profile_edit_page.dart';

class CustomProfile extends StatefulWidget {
  const CustomProfile({
    required this.isVisible,
    super.key});

  final bool isVisible;

  @override
  State<CustomProfile> createState() => _CustomProfileState();
}

class _CustomProfileState extends State<CustomProfile> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: readProfiles(),
        builder: (context, snapshot){
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
            final profiles = snapshot.data!;
            return Center(
              child: ListView(
                shrinkWrap: true,
                children: profiles.map(buildProfile).toList(),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  Widget buildProfile (Profile profile){
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFFFDC600), width: 2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/dlsublimarte-linkrapido.appspot.com/o/images%2F${profile.profileImage}?alt=media'),
            ),
          ),
          const SizedBox(height: 5),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(profile.title,
                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Color(0xFFFDC600),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.verified_sharp, color: Colors.blue,),
              Offstage(
                offstage: widget.isVisible,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ProfileEditPage(title: profile.title, subtitle: profile.subtitle, profileImage: profile.profileImage, id: profile.id,))),
                  ),
              ),
            ],
          ),
          Text(profile.subtitle,
            style: const TextStyle(fontSize: 12,fontStyle: FontStyle.italic, color: Color(0xFFFDC600,),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Profile>> readProfiles() => FirebaseFirestore.instance
      .collection('profile')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Profile.fromJson(doc.data())).toList());

  Future<Profile?> readProfile() async {
    final docProfile = FirebaseFirestore.instance.collection('profile').doc();
    final snapshot = await docProfile.get();
    if (snapshot.exists) {
      return Profile.fromJson(snapshot.data()!);
    }
    return null;
  }
}
