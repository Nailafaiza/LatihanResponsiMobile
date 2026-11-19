import 'package:flutter/material.dart';
import 'package:latres/pages/detail.dart';
import 'package:latres/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'spells.dart';

import '../api/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> characters = [];
  bool isLoading = true;

  Future<void> fetchCharacters() async {
    //kode yg bisa jadi gagal
    try {
      final characterData = await getCharacters();
      setState(() {
        characters = characterData;
        isLoading = false;
      });
    } catch (e) {
      //dijalankan jika kode di try gagal
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _logout() async {
    final authPref = await SharedPreferences.getInstance();
    await authPref.remove('isLoggedIn');
    await authPref.remove('username');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Success!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Logged out Successfully',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];

                      return ListTile(
                        leading: Image.network(
                          character['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(character['fullName']),
                        subtitle: Text(character['interpretedBy'] ?? '-'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(characterId: character['index']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SpellsPage()),
                        );
                      },
                      child: const Text('Spells'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}