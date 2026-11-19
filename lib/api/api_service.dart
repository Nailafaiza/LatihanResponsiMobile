import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latres/models/todo.dart';

String apiUrl1 = 'https://potterapi-fedeperin.vercel.app/en/characters';
String apiUrl2 = 'https://potterapi-fedeperin.vercel.app/en/spells';

Future<List<dynamic>> getCharacters() async {
  final response = await http.get(Uri.parse(apiUrl1));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load characters');
  }
}

Future<Map<String, dynamic>> getSingleCharacter(int characterId) async{
  final response = await http.get(Uri.parse('$apiUrl1?index=$characterId'));
  if (response.statusCode == 200){
    final data = jsonDecode(response.body);
    return data;
  }else{
    throw Exception('Failed to load character details');
  }
}

Future<List<Todo>> getSpells() async {
  final response = await http.get(Uri.parse(apiUrl2));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

   return data.map((item) => Todo.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load spells');
  }
}