import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Colombia'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Explora Colombia',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Descubre informacion sobre departamentos, presidentes, atracciones turisticas y aeropuertos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Grid of cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                // Departments Card
                DashboardCard(
                  title: 'Departamentos',
                  subtitle: 'Explora los 32 departamentos',
                  icon: Icons.map,
                  color: const Color(0xFF003893),
                  onTap: () => context.push('/departments'),
                ),

                // Presidents Card
                DashboardCard(
                  title: 'Presidentes',
                  subtitle: 'Historia presidencial',
                  icon: Icons.account_balance_outlined,
                  color: const Color(0xFFCE1126), // Red
                  onTap: () => context.push('/presidents'),
                ),

                // Touristic Attractions Card
                DashboardCard(
                  title: 'Atracciones',
                  subtitle: 'Lugares turisticos',
                  icon: Icons.attractions_outlined,
                  color: const Color(0xFFFCD116), // Yellow
                  onTap: () => context.push('/attractions'),
                ),

                // Airports Card
                DashboardCard(
                  title: 'Aeropuertos',
                  subtitle: 'Infraestructura aerea',
                  icon: Icons.flight_outlined,
                  color: const Color(0xFF009739), // Green
                  onTap: () => context.push('/airports'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // API Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF003893),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Acerca de la API',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Esta aplicacion consume la API publica de Colombia, '
                      'proporcionando informacion detallada sobre diferentes aspectos '
                      'del pais.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'API Base: https://api-colombia.com',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: const Color(0xFF003893),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
