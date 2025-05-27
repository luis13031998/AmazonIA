import 'package:flutter/material.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget ? title;
  final bool hideBack;
  const BasicAppbar({
    this.title,
    this.hideBack = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      leading: hideBack ? null : IconButton(
        onPressed: () {
          Navigator.pop(context); // Para volver atrás
        },
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.04)
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
