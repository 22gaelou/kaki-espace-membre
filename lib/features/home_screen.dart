import 'package:flutter/material.dart';
import 'package:kaki/features/settings/settings_view.dart';
import 'package:kaki/features/wallet/wallet_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ViewState { settings, wallet }

class _HomeScreenState extends State<HomeScreen> {
  ViewState _currentView = ViewState.settings;

  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRealProfile();
  }

  Future<void> _fetchRealProfile() async {
    try {
      // Petite pause pour laisser Supabase récupérer la session depuis l'URL (si on arrive de l'app mobile via un Magic Link ou Token)
      await Future.delayed(const Duration(milliseconds: 1000));

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              "Vous n'êtes pas connecté. Veuillez cliquer sur 'Membre Premium' depuis l'application Kaki pour accéder à cette page.";
        });
        return;
      }

      // Récupérer le profil
      final data = await Supabase.instance.client
          .from('users')
          .select('id, full_name, username, diamonds')
          .eq('id', user.id)
          .single();

      setState(() {
        _profile = {
          'id': data['id'],
          'full_name': data['full_name'] ?? data['username'] ?? 'Membre Kaki',
          'school_class': 'Actif', // ou toute autre info pertinente
          'diamonds_balance': data['diamonds'] ?? 0,
          'is_premium': false, // Si abonnement géré ailleurs
          'next_billing_date': null,
        };
        _isLoading = false;
      });

      // Écouter les changements de solde de diamants en temps réel (pour voir la balance monter tout de suite après achat)
      Supabase.instance.client
          .from('users')
          .stream(primaryKey: ['id'])
          .eq('id', user.id)
          .listen((List<Map<String, dynamic>> data) {
            if (data.isNotEmpty && mounted) {
              setState(() {
                _profile?['diamonds_balance'] = data[0]['diamonds'] ?? 0;
              });
            }
          });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Erreur de chargement du profil: $e";
        });
      }
    }
  }

  void _navigateToWallet() {
    setState(() {
      _currentView = ViewState.wallet;
    });
  }

  void _navigateBack() {
    setState(() {
      _currentView = ViewState.settings;
    });
  }

  void _updateDiamonds(int amountToAdd) {
    // Ne fait rien de manuel ici, le Stream listener ci-dessus s'en occupe en temps réel via Supabase
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    if (_errorMessage != null || _profile == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              _errorMessage ?? "Erreur inconnue",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentView == ViewState.settings
              ? SettingsView(
                  profile: _profile!,
                  onWalletTapped: _navigateToWallet,
                )
              : WalletView(
                  profile: _profile!,
                  onBackTapped: _navigateBack,
                  onPaymentSuccess: _updateDiamonds,
                ),
        ),
      ),
    );
  }
}
