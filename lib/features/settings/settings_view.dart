import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsView extends StatelessWidget {
  final Map<String, dynamic> profile;
  final VoidCallback onWalletTapped;

  const SettingsView({
    super.key,
    required this.profile,
    required this.onWalletTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Profil
              _buildProfileHeader(),
              const SizedBox(height: 48),

              // Bouton Portefeuille
              _buildWalletButton(),
              const SizedBox(height: 32),

              // Options
              _buildSettingsOption(
                context,
                LucideIcons.user,
                'Informations personnelles',
              ),
              _buildSettingsOption(context, LucideIcons.shield, 'Sécurité'),
              _buildSettingsOption(context, LucideIcons.bell, 'Notifications'),
              const SizedBox(height: 48),

              // Déconnexion
              TextButton.icon(
                onPressed: () {
                  // TODO: Implémenter la déconnexion Supabase
                  // Supabase.instance.client.auth.signOut();
                },
                icon: const Icon(LucideIcons.logOut, color: Colors.redAccent),
                label: const Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFF2A2A2A),
          child: Text(
            profile['full_name'][0].toUpperCase(),
            style: const TextStyle(
              fontSize: 40,
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile['full_name'],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            profile['school_class'],
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletButton() {
    return InkWell(
      onTap: onWalletTapped,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF332B00), Color(0xFF1A1500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.wallet,
                  color: Color(0xFFFFD700),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mon Portefeuille',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile['diamonds_balance']} 💎',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(LucideIcons.chevronRight, color: Color(0xFFFFD700)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(
        LucideIcons.chevronRight,
        color: Colors.white24,
        size: 20,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.info, color: Color(0xFFFFD700), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Veuillez gérer vos informations directement depuis l\'application mobile KAKI.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2A2A2A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      },
    );
  }
}
