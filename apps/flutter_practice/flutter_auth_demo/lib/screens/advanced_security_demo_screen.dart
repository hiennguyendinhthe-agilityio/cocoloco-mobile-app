import 'package:flutter/material.dart';
import 'encryption_demo_screen.dart';
import 'secure_storage_demo_screen.dart';

class AdvancedSecurityDemoScreen extends StatefulWidget {
  const AdvancedSecurityDemoScreen({super.key});

  @override
  State<AdvancedSecurityDemoScreen> createState() => _AdvancedSecurityDemoScreenState();
}

class _AdvancedSecurityDemoScreenState extends State<AdvancedSecurityDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Security Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.lock_outline), text: 'Secure Storage'),
            Tab(icon: Icon(Icons.security), text: 'Data Encryption'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SecureStorageDemoScreen(),
          EncryptionDemoScreen(),
        ],
      ),
    );
  }
}
