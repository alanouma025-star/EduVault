import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final List<String> menu = [
    'Dashboard',
    'Materials',
    'Users',
    'Quizzes',
    'Reports',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EduVault Admin'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'EduVault\nAdministrator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (int i = 0; i < menu.length; i++)
              ListTile(
                leading: Icon(_iconFor(i)),
                title: Text(menu[i]),
                selected: selectedIndex == i,
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: _buildPage(),
    );
  }

  IconData _iconFor(int index) {
    const icons = [
      Icons.dashboard,
      Icons.library_books,
      Icons.people,
      Icons.quiz,
      Icons.report,
      Icons.settings,
    ];
    return icons[index];
  }

  Widget _buildPage() {
    switch (selectedIndex) {
      case 1:
        return _materialsPage();
      case 2:
        return _usersPage();
      case 3:
        return _quizzesPage();
      case 4:
        return _reportsPage();
      case 5:
        return _settingsPage();
      default:
        return _dashboardPage();
    }
  }

  Widget _dashboardPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Control and manage EduVault.'),
        const SizedBox(height: 24),

        _card('Users', '0', Icons.people),
        _card('Learning Materials', '0', Icons.library_books),
        _card('Quizzes', '0', Icons.quiz),
        _card('Pending Reports', '0', Icons.report),

        const SizedBox(height: 20),

        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        ListTile(
          leading: const Icon(Icons.upload_file),
          title: const Text('Upload Lecture Notes'),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add Subject'),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.add_task),
          title: const Text('Create Quiz'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _card(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 35),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _materialsPage() {
    return const Center(
      child: Text(
        'Materials Management\n\nAdd, approve, reject and delete notes.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _usersPage() {
    return const Center(
      child: Text(
        'User Management\n\nView and manage EduVault users.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _quizzesPage() {
    return const Center(
      child: Text(
        'Quiz Management\n\nCreate and manage quizzes.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _reportsPage() {
    return const Center(
      child: Text(
        'Reports & Moderation\n\nReview reported content and users.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _settingsPage() {
    return const Center(
      child: Text(
        'Admin Settings\n\nManage EduVault settings.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
