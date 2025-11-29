import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // =====================================================
  // SUBIR ARCHIVO A STORAGE
  // =====================================================
  Future<String> uploadFile(String path, String folder) async {
    final file = File(path);

    final ref = FirebaseStorage.instance
        .ref()
        .child("users/$uid/$folder/${DateTime.now().millisecondsSinceEpoch}");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  // =====================================================
  // CAMBIAR FOTO DE PERFIL
  // =====================================================
  Future<void> changeProfilePhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String url = await uploadFile(file.path, "profile");

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "photoUrl": url,
      });
    }
  }

  // =====================================================
  // CAMBIAR PORTADA
  // =====================================================
  Future<void> changeCoverPhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String url = await uploadFile(file.path, "cover");

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "portadaUrl": url,
      });
    }
  }

  // =====================================================
  // EDITAR CAMPOS DE TEXTO
  // =====================================================
  void editField(String key, String value) async {
    TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar $key"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .update({key: controller.text});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // VISTA COMPLETA DEL PERFIL
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final photoUrl = data["photoUrl"] ?? "";
          final portadaUrl = data["portadaUrl"] ?? "";
          final fullName = data["fullName"] ?? "";
          final description = data["description"] ?? "";
          final grado = data["grado"] ?? "";

          return SingleChildScrollView(
            child: Column(
              children: [
                // PORTADA
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: portadaUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(portadaUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[300],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton.small(
                        onPressed: changeCoverPhoto,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // FOTO DE PERFIL
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : const AssetImage("assets/default_profile.png")
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton.small(
                        onPressed: changeProfilePhoto,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // NOMBRE
                GestureDetector(
                  onTap: () => editField("fullName", fullName),
                  child: Text(
                    fullName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 5),

                // GRADO
                GestureDetector(
                  onTap: () => editField("grado", grado),
                  child: Text(
                    grado,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // DESCRIPCIÓN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => editField("description", description),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
