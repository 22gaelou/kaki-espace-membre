import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/home_screen.dart';

// TODO: Remplacer par vos vraies clés Supabase
// Vous trouverez ces clés dans les paramètres de votre projet Supabase (Settings -> API)
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const KakiWebApp());
}

final supabase = Supabase.instance.client;

class KakiWebApp extends StatelessWidget {
  const KakiWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAKI - Espace Membre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Gris très foncé
        primaryColor: const Color(0xFFFFD700), // Doré/Jaune
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFFACC15),
          surface: Color(0xFF1E1E1E),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.dark().textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.white),
            bodyMedium: const TextStyle(color: Colors.white70),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
