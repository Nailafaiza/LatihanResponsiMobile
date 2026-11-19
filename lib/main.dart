import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../pages/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter(); 
  Hive.registerAdapter(TodoAdapter()); 
  await Hive.openBox<Todo>('favoriteSpellsPage');

  // Inisialisasi notifikasi
  await NotificationService().init();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}
