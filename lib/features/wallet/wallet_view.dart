import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    setState(() {
      _isLoading = true;
    });

    // Simulation du paiement (ex: API Wave, Orange Money, etc.)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Succès!
    widget.onPaymentSuccess(diamonds);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Paiement de $price FCFA réussi ! +$diamonds 💎'),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
