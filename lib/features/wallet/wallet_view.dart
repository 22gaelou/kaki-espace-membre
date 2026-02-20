import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletView extends StatefulWidget {
  final Map<String, dynamic> profile;
  final VoidCallback onBackTapped;
  final Function(int) onPaymentSuccess;

  const WalletView({
    super.key,
    required this.profile,
    required this.onBackTapped,
    required this.onPaymentSuccess,
  });

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  bool _isLoading = false;

  void _handlePayment(int diamonds, int price) async {
    // 1. Lancement du Dialog Web/Wave
    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Empêcher la fermeture pendant le chargement
      builder: (context) =>
          WaveSandboxDialog(diamondsAmount: diamonds, amountFcfa: price),
    );

    // 2. Gestion du résultat
    if (success == true) {
      if (!mounted) return;

      // Callback pour mettre à jour l'UI ou parent si nécessaire
      widget.onPaymentSuccess(diamonds);

      // Afficher un message de succès éclatant
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('🎉 Félicitations !', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paiement simulé réussi !',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Vos $diamonds diamants 💎 ont été ajoutés à votre compte.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Vous pouvez maintenant retourner dans l\'application KAKI. Le solde s\'est déjà mis à jour !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compris !'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrowLeft),
                        onPressed: widget.onBackTapped,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'La Boutique KAKI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Solde actuel
                  _buildBalanceCard(),
                  const SizedBox(height: 48),

                  const Text(
                    'Recharger mes diamants',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Packs
                  _buildPriceCard(
                    title: 'Pack Découverte',
                    diamonds: 500,
                    price: 500,
                  ),
                  _buildPriceCard(
                    title: 'Pack Élite',
                    diamonds: 1200,
                    price: 1000,
                    isPopular: true,
                  ),
                  _buildPriceCard(
                    title: 'Pack Master',
                    diamonds: 3000,
                    price: 2500,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Solde actuel',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.gem, color: Color(0xFFFFD700), size: 40),
              const SizedBox(width: 16),
              Text(
                '${widget.profile['diamonds_balance']}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.profile['is_premium']
                  ? const Color(0xFFFFD700).withValues(alpha: 0.2)
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.profile['is_premium']
                    ? const Color(0xFFFFD700)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              widget.profile['is_premium']
                  ? '🌟 Membre Premium'
                  : 'Membre Standard',
              style: TextStyle(
                color: widget.profile['is_premium']
                    ? const Color(0xFFFFD700)
                    : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard({
    required String title,
    required int diamonds,
    required int price,
    bool isPopular = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: isPopular
            ? Border.all(color: const Color(0xFFFFD700), width: 2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (isPopular)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'POPULAIRE',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.gem,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$diamonds 💎',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _handlePayment(diamonds, price),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF2A2A2A),
                    foregroundColor: isPopular ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '$price FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WaveSandboxDialog extends StatefulWidget {
  final int amountFcfa;
  final int diamondsAmount;

  const WaveSandboxDialog({
    super.key,
    required this.amountFcfa,
    required this.diamondsAmount,
  });

  @override
  State<WaveSandboxDialog> createState() => _WaveSandboxDialogState();
}

class _WaveSandboxDialogState extends State<WaveSandboxDialog> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _processPayment() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      setState(() => _errorMessage = 'Veuillez entrer un numéro valide.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Attente simulée de 2 secondes
      await Future.delayed(const Duration(seconds: 2));

      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // TRANSACTION SUPABASE ATOMIQUE (RPC recommandé en prod, on fait simple ici)

      // 1. Récupération du solde actuel
      final profileData = await supabase
          .from('users')
          .select('diamonds')
          .eq('id', userId)
          .single();

      final currentDiamonds = (profileData['diamonds'] as int?) ?? 0;
      final newBalance = currentDiamonds + widget.diamondsAmount;

      // 2. Mise à jour de la table des utilisateurs
      await supabase
          .from('users')
          .update({'diamonds': newBalance})
          .eq('id', userId);

      // 3. Enregistrement de la transaction dans l'historique
      await supabase.from('transactions').insert({
        'user_id': userId,
        'amount_fcfa': widget.amountFcfa,
        'diamonds_credited': widget.diamondsAmount,
        'status': 'success',
        'payment_provider': 'wave',
      });

      // 4. Succès
      if (mounted) {
        Navigator.pop(
          context,
          true,
        ); // Fermer le dialog en retournant "true" (succès)
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Échec de la transaction. Veuillez réessayer.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Look Wave
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🌊', // Remplace par l'image du logo Wave
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Wave Sandbox',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF141F61), // Bleu Wave approximatif
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Achat de ${widget.diamondsAmount} 💎',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Montant : ${widget.amountFcfa} FCFA',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Votre numéro Wave',
                prefixText: '+225 ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              enabled: !_isLoading,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141F61), // Code couleur Wave
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Valider le paiement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
