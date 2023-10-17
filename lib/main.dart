import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
 
class _MyAppState extends State<MyApp> {

  final String apiUrl = "http://192.168.100.168/latihan/data.php";
  
 
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
 
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BELAJAR API'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: Image.network('http://192.168.100.168/latihan/img/' + snapshot.data![index]['avatar'])
                        .image,
                  ),
                  title: Text(snapshot.data![index]['first_name'] + " " + snapshot.data![index]['last_name']),
                  subtitle: Text(snapshot.data![index]['produk']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
 