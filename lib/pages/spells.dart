import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/models/todo.dart';
import 'package:latres/pages/favorite.dart';
import 'package:latres/pages/home.dart';
import 'package:latres/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class SpellsPage extends StatefulWidget {
  const SpellsPage({super.key});

  @override
  State<SpellsPage> createState() => _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  List<Todo> spells = [];
  bool isLoading = true;

  // Pastikan box 'favoriteSpells' sudah dibuka di main.dart
  final box = Hive.box<Todo>('favoriteSpellsPage');

  Future<void> fetchSpells() async {
    try {
      final spellsData = await getSpells();

      if (!mounted) return;

      setState(() {
        spells = spellsData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print('Error: $e');
    }
  }

  Future<void> toggleFavorite(Todo spell) async {
    // Menggunakan spell.spell sebagai unique key di dalam Hive
    if (box.containsKey(spell.spell)) {
      await box.delete(spell.spell);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed successfully from fav list!'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 800),
        ),
      );
    } else {
      await box.put(spell.spell, spell);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added successfully to fav list!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );
    }

    // Memperbarui UI agar ikon hati langsung berubah warna
    setState(() {});
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
    fetchSpells();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : spells.isEmpty
              ? const Center(child: Text('Data spells kosong'))
              : ListView.builder(
                  itemCount: spells.length,
                  itemBuilder: (context, index) {
                    final spell = spells[index];

                    // Cek apakah spell ini sudah tersimpan di Hive
                    final isFavorite = box.containsKey(spell.spell);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(spell.spell), // Menampilkan nama mantra
                        subtitle: Text(spell.use),  // Menampilkan fungsi/kegunaan mantra
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : Colors.black54,
                          ),
                          onPressed: () {
                            toggleFavorite(spell);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Menggunakan .then untuk me-refresh halaman ketika kembali dari FavoritePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritePage(),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.favorite),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          child: const Text('Characters'),
        ),
      ),
    );
  }
}