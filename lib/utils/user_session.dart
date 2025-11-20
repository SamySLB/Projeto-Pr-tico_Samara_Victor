class UserSession {
  static final UserSession instance = UserSession._();
  UserSession._();

  String email = "";
  String senha = "";
  String nome = "Nome Completo";
}