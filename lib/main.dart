import 'package:flutter/material.dart';

void main() {
  runApp(const VolumeApp());
}

class VolumeApp extends StatelessWidget {
  const VolumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Volume',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📐 Kalkulator Volume'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            
            // Card Kubus
            _buildShapeCard(
              emoji: '🔲', title: 'Kubus', subtitle: 'V = s³', color: Colors.blue,
              onTap: () => print('Kubus ditekan'),
            ),
            const SizedBox(height: 12),
            
            // Card Tabung
            _buildShapeCard(
              emoji: '🛢️', title: 'Tabung', subtitle: 'V = π × r² × h', color: Colors.green,
              onTap: () => print('Tabung ditekan'),
            ),
            const SizedBox(height: 12),
            
            // Card Bola
            _buildShapeCard(
              emoji: '⚽', title: 'Bola', subtitle: 'V = 4/3 × π × r³', color: Colors.orange,
              onTap: () => print('Bola ditekan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeCard({
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