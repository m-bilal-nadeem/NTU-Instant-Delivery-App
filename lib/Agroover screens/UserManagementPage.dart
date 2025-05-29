import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntu_instant_delievery/Models/UserModel.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  TextEditingController _searchController = TextEditingController();
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    _allUsers = snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      _filteredUsers = _allUsers;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final name = user.fullname?.toLowerCase() ?? "";
        final email = user.email?.toLowerCase() ?? "";
        return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _deleteUser(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
    fetchUsers(); // Refresh
  }

  void _suspendUser(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "suspended": true,
    });
    fetchUsers();
  }

  void _showUserOptions(UserModel user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("View Profile"),
                subtitle: Text(user.email ?? "No email"),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete User"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteUser(user.uid!);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_person, color: Colors.orange),
                title: const Text("Suspend User"),
                onTap: () {
                  Navigator.pop(context);
                  _suspendUser(user.uid!);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: "Search by name or email",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text("No users found"))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        leading: CircleAvatar(
                          backgroundImage: user.profilepic != null && user.profilepic!.isNotEmpty
                              ? NetworkImage(user.profilepic!)
                              : null,
                          backgroundColor: Colors.green[100],
                          child: (user.profilepic == null || user.profilepic!.isEmpty)
                              ? const Icon(Icons.person, color: Colors.green)
                              : null,
                        ),
                        title: Text(user.fullname ?? "Unnamed"),
                        subtitle: Text(user.email ?? "No email"),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () => _showUserOptions(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
