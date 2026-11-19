import 'package:flutter/material.dart';
import 'package:latres/api/api_service.dart';

class DetailPage extends StatefulWidget {
  final int characterId;
  const DetailPage({super.key, required this.characterId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> character = {};
  bool isLoading = true;

  Future<void> fetchSingleCharacter() async {
    final characterData = await getSingleCharacter(widget.characterId);

    setState(() {
      character = characterData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSingleCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Character')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    character['image'],
                    width: double.infinity,
                    height: 300,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsetsGeometry.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(character['fullName']),
                        const SizedBox(height: 8),

                        const Text(
                          'Nickname',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(character['nickname']),
                        const SizedBox(height: 8),

                        const Text(
                          'Hogwarts House',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(character['hogwartsHouse']),
                        const SizedBox(height: 8),

                        const Text(
                          'Interpreted By',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(character['interpretedBy']),
                        const SizedBox(height: 8),

                        const Text(
                          'Children',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text((character['children'] as List).join(', ')),
                        const SizedBox(height: 8),

                        const Text(
                          'Birthdate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(character['birthdate']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
