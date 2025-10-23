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

  // 🧩 Cargar datos guardados localmente
  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? nombre;
      descripcion = prefs.getString('descripcion') ?? descripcion;
      grado = prefs.getString('grado') ?? grado;
      String? pathPerfil = prefs.getString('fotoPerfil');
      String? pathPortada = prefs.getString('fotoPortada');
      if (pathPerfil != null && File(pathPerfil).existsSync()) {
        fotoPerfil = File(pathPerfil);
      }
      if (pathPortada != null && File(pathPortada).existsSync()) {
        fotoPortada = File(pathPortada);
      }
    });
  }

  // 💾 Guardar cambios
  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombre);
    await prefs.setString('descripcion', descripcion);
    await prefs.setString('grado', grado);
    if (fotoPerfil != null) await prefs.setString('fotoPerfil', fotoPerfil!.path);
    if (fotoPortada != null) await prefs.setString('fotoPortada', fotoPortada!.path);
  }

  Future<void> _editarPerfil() async {
    TextEditingController nombreController = TextEditingController(text: nombre);
    TextEditingController descripcionController =
        TextEditingController(text: descripcion);
    TextEditingController gradoController = TextEditingController(text: grado);

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
                    await _guardarDatos(); // 🔥 Guarda los cambios
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
      await _guardarDatos(); // 🔥 Guarda la nueva imagen
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode
        ? Colors.amberAccent
        : const Color.fromARGB(221, 251, 167, 21);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _cambiarFoto(true),
            child: fotoPortada != null
                ? Image.file(fotoPortada!,
                    fit: BoxFit.cover, height: size.height, width: size.width)
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
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
                            // Foto perfil
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
                                    child: const Icon(Icons.check,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.pink),
                              onPressed: _editarPerfil,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Nombre y grado alineados
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              grado,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
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
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isDarkMode ? Colors.grey[300] : Colors.black87,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Divider(
                        color: isDarkMode ? Colors.white12 : Colors.black12,
                      ),
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _FriendAndMore(
                              title: "AMIGOS",
                              number: "24",
                              textColor: Color.fromARGB(255, 248, 245, 245),
                              subtitleColor: Color.fromARGB(248, 238, 152, 31),
                            ),
                            _FriendAndMore(
                              title: "SIGUIENDO",
                              number: "28",
                              textColor: Color.fromARGB(255, 248, 245, 245),
                              subtitleColor: Color.fromARGB(248, 238, 152, 31),
                            ),
                            _FriendAndMore(
                              title: "SEGUIDORES",
                              number: "134",
                              textColor: Color.fromARGB(255, 248, 245, 245),
                              subtitleColor: Color.fromARGB(248, 238, 152, 31),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
