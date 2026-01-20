import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'signup_page.dart';
import '../screens/main_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const Color tertiaryColor = Color(0xFFD78FEE);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                    'assets/images/logo_festival.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.movie, size: 100, color: tertiaryColor)
                ),
                const SizedBox(height: 40),
                const Text(
                    "FEFFS 2026",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 30),

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputStyle("Email", Icons.email_outlined),
                  validator: (val) => val!.isEmpty ? "Entrez votre email" : null,
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: _inputStyle("Mot de passe", Icons.lock_outline),
                  validator: (val) => val!.length < 6 ? "Minimum 6 caractères" : null,
                ),
                const SizedBox(height: 30),

                // Bouton de connexion
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tertiaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SE CONNECTER", style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage())
                  ),
                  child: const Text(
                      "Pas de compte ? Créer un profil",
                      style: TextStyle(color: tertiaryColor)
                  ),
                ),

                // Lien continuer sans compte
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainWrapper())
                  ),
                  child: const Text(
                      "Continuer sans compte",
                      style: TextStyle(color: Colors.grey)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFD78FEE)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await AuthService().signIn(
            _emailController.text.trim(),
            _passController.text.trim()
        );
        if (mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainWrapper())
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Erreur : Email ou mot de passe incorrect"),
                backgroundColor: Colors.redAccent
            )
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}