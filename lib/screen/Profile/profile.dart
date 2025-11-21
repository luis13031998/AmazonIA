import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nombre = "Luis Leandro";
  String descripcion =
      "Me encanta leer libros en mis ratos libre acompañado de mis amigos es uno de mis hobbies y mis ideales.";
  String grado = "Alumno de 5to de secundaria";

  File? fotoPerfil;
  File? fotoPortada;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? nombre;
      descripcion = prefs.getString('descripcion') ?? descripcion;
      grado = prefs.getString('grado') ?? grado;

      String? p1 = prefs.getString('fotoPerfil');
      String? p2 = prefs.getString('fotoPortada');

      if (p1 != null && File(p1).existsSync()) fotoPerfil = File(p1);
      if (p2 != null && File(p2).existsSync()) fotoPortada = File(p2);
    });
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nombre', nombre);
    prefs.setString('descripcion', descripcion);
    prefs.setString('grado', grado);

    if (fotoPerfil != null) prefs.setString('fotoPerfil', fotoPerfil!.path);
    if (fotoPortada != null) prefs.setString('fotoPortada', fotoPortada!.path);
  }

  Future<void> _editarPerfil() async {
    final nombreController = TextEditingController(text: nombre);
    final descripcionController = TextEditingController(text: descripcion);
    final gradoController = TextEditingController(text: grado);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Editar Perfil",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField("Nombre", nombreController),
                const SizedBox(height: 10),
                _buildTextField("Grado o descripción breve", gradoController),
                const SizedBox(height: 10),
                _buildTextField("Biografía", descripcionController, maxLines: 3),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      nombre = nombreController.text;
                      descripcion = descripcionController.text;
                      grado = gradoController.text;
                    });
                    await _guardarDatos();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Guardar cambios"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cambiarFoto(bool esPortada) async {
    final picker = ImagePicker();
    final XFile? imagen =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (imagen != null) {
      setState(() {
        if (esPortada) {
          fotoPortada = File(imagen.path);
        } else {
          fotoPerfil = File(imagen.path);
        }
      });
      _guardarDatos();
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black;
    final bioColor = isDark ? Colors.grey[300] : Colors.black87;
    final subtitleColor =
        isDark ? Colors.amberAccent : const Color.fromARGB(221, 251, 167, 21);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _cambiarFoto(true),
            child: fotoPortada != null
                ? Image.file(
                    fotoPortada!,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
                  )
                : Image.asset(
                    AppImages.introBG,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: size.height * 0.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => _cambiarFoto(false),
                                  child: CircleAvatar(
                                    radius: 42,
                                    backgroundImage: fotoPerfil != null
                                        ? FileImage(fotoPerfil!)
                                        : const AssetImage(AppImages.perfilNino)
                                            as ImageProvider,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 95, 225, 99),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              onPressed: _editarPerfil,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              grado,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          descripcion,
                          style: TextStyle(
                            fontSize: 13,
                            color: bioColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Divider(
                          color: isDark ? Colors.white12 : Colors.black12),
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _FriendAndMore(
                              title: "AMIGOS",
                              number: "24",
                              textColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            _FriendAndMore(
                              title: "SIGUIENDO",
                              number: "28",
                              textColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            _FriendAndMore(
                              title: "SEGUIDORES",
                              number: "134",
                              textColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FriendAndMore extends StatelessWidget {
  final String title;
  final String number;
  final Color textColor;
  final Color subtitleColor;

  const _FriendAndMore({
    super.key,
    required this.title,
    required this.number,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
