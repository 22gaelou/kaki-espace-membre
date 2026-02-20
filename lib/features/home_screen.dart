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

  // Mock utilisateur pour l'instant (à remplacer par de vraies requêtes Supabase via la table 'profiles')
  final Map<String, dynamic> _mockProfile = {
    'id': '123e4567-e89b-12d3-a456-426614174000',
    'full_name': 'Gael',
    'school_class': 'Terminale D',
    'diamonds_balance': 150,
    'is_premium': false,
    'next_billing_date': null,
  };

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
    setState(() {
      _mockProfile['diamonds_balance'] += amountToAdd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentView == ViewState.settings
              ? SettingsView(
                  profile: _mockProfile,
                  onWalletTapped: _navigateToWallet,
                )
              : WalletView(
                  profile: _mockProfile,
                  onBackTapped: _navigateBack,
                  onPaymentSuccess: _updateDiamonds,
                ),
        ),
      ),
    );
  }
}
