import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<int> getRandomNumber() async {
    final response = await http.get(Uri.parse(
        'https://cors-anywhere.herokuapp.com/https://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0];
    } else {
      throw Exception('Failed to load random number');
    }
  }
}
