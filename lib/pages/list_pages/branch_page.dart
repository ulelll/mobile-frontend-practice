import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/branch_controller.dart';
import '../../widgets/branch_card.dart';
import '../../widgets/sidebar_menu.dart';
import '../details page/branch_detail_page.dart';

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  State<BranchPage> createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  bool _isSidebarOpen = false;
  final BranchController controller = Get.put(BranchController());

  @override
  void initState() {
    super.initState();
    controller.fetchBranches();
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
                        "Branch",
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
                      hintText: "Search Branch...",
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

                  // branch List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.branches.isEmpty) {
                        return const Center(child: Text('No branches found'));
                      }

                      return ListView.builder(
                        itemCount: controller.branches.length,
                        itemBuilder: (context, index) {
                          final branch = controller.branches[index];
                          return BranchCard(
                            branch: branch,
                            onTap: () {
                              Get.to(() => BranchDetailPage(
                                branchId: branch['id'],
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

      //add new branch button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add branch button clicked')),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Branch",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
