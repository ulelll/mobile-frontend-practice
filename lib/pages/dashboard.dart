import 'package:flutter/material.dart';
import '../widgets/sidebar_menu.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  bool _isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            _isSidebarOpen = true;
                          });
                        },
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/rukia.jpg'),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Dashboard Utama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Example grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: const [
                        DashboardCard(title: "Total Company", value: "10"),
                        DashboardCard(title: "Total Branch", value: "145"),
                        DashboardCard(title: "Total Warehouse", value: "328"),
                        DashboardCard(title: "Product", value: "328"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sidebar
        AnimatedSlide(
            offset: _isSidebarOpen ? Offset.zero : const Offset(-1.0, 0.0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: _isSidebarOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: SidebarMenu(
                onClose: () {
                  setState(() {
                    _isSidebarOpen = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.business, color: Colors.red[300]),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
