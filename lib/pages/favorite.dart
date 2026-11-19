import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/models/todo.dart';
import 'package:latres/services/notification_service.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoBox = Hive.box<Todo>('favoriteSpellsPage');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spell'),
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          final favoriteSpells = box.values.toList();

          if (favoriteSpells.isEmpty) {
            return const Center(
              child: Text('Belum ada spell favorit.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteSpells.length,
            itemBuilder: (context, index) {
              final spellItem = favoriteSpells[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.black87),
                  title: Text(
                    spellItem.spell,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(spellItem.use),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final deletedSpellName = spellItem.spell;

                      // 1. Hapus dari Hive berdasarkan key (spellItem.spell)
                      await box.delete(spellItem.spell);

                      // 2. Tampilkan Immediate Notification 
                      await NotificationService().showInstantNotification(
                        title: 'Delete notification',
                        body: 'You deleted $deletedSpellName from your fav list!',
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}