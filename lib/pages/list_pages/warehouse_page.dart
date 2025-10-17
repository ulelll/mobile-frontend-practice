import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/warehouse_controller.dart';
import '../../widgets/warehouse_card.dart';
import '../../widgets/sidebar_menu.dart';
import '../details page/warehouse_detail_page.dart';
import 'package:mobile_sigma_app/routes/routes.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  bool _isSidebarOpen = false;
  final  WarehouseController controller = Get.put(WarehouseController());

  @override
  void initState() {
    super.initState();
    controller.fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Main Content
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
                      const Text(
                        "Warehouse",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF303030),
                        ),
                      ),
                        Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Get.toNamed('/profile');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/rukia.jpg'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search warehouse...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // warehause List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.warehouses.isEmpty) {
                        return const Center(child: Text('No warehouses found'));
                      }

                      return ListView.builder(
                        itemCount: controller.warehouses.length,
                        itemBuilder: (context, index) {
                          final warehouse = controller.warehouses[index];
                          return WarehouseCard(
                            warehouse: warehouse,
                            onTap: () {
                              Get.to(() => WarehouseDetailPage(
                                warehouseId: warehouse['id'],
                              ));
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          //sidebar
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

      //add new warehouse button
      floatingActionButton: FloatingActionButton.extended(
         onPressed: () {
          Get.toNamed(Routes.warehouseCreateRoute());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Warehouse",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
