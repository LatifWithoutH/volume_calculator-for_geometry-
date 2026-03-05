import 'package:flutter/material.dart';
import 'pages/kubus_page.dart';
import 'pages/tabung_page.dart';
import 'pages/bola_page.dart';
import 'pages/settings_page.dart'; // Import settings

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📐 Kalkulator Volume'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Tombol Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Bangun Ruang:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildShapeCard(
              context,
              emoji: '🔲',
              title: 'Kubus',
              subtitle: 'V = s³',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KubusPage()),
              ),
            ),
            const SizedBox(height: 12),
            _buildShapeCard(
              context,
              emoji: '🛢️',
              title: 'Tabung',
              subtitle: 'V = π × r² × h',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TabungPage()),
              ),
            ),
            const SizedBox(height: 12),
            _buildShapeCard(
              context,
              emoji: '⚽',
              title: 'Bola',
              subtitle: 'V = 4/3 × π × r³',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BolaPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeCard(BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}