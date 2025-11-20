import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/user_session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    //Atualiza a UI quando o usuário clica no campo
    nameFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFED213A), Color(0xFF93291E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(27),
          child: Column(
            children: [
              const SizedBox(height: 110),
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2016/07/23/13/21/pokemon-1536855_1280.png",
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Meu Perfil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              //nome
              CupertinoTextField(
                controller: nameController,
                focusNode: nameFocus,
                cursorColor: Colors.pinkAccent,
                padding: const EdgeInsets.all(15),
                placeholder: nameFocus.hasFocus ? "" : UserSession.instance.nome,
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 15),
              //email
              CupertinoTextField(
                controller: emailController,
                focusNode: emailFocus,
                cursorColor: Colors.pinkAccent,
                padding: const EdgeInsets.all(15),
                placeholder: emailFocus.hasFocus ? "" : UserSession.instance.email,
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(17),
                  color: Colors.greenAccent,
                  child: const Text(
                    "Salvar alterações",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if(nameController.text != "") {
                      UserSession.instance.nome = nameController.text;
                    }
                    if(emailController.text != "") {
                      UserSession.instance.email = emailController.text;
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}