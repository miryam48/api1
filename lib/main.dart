import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main(){
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: myapp(),));
}
class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  Future post()async{
    Map data = {
      'title':title.text,
      'description':desc.text
    };
    final response = await http.post(Uri.parse('https://api.nstack.in/v1/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data)
    );
    if(response.statusCode ==200);
      get();
  }

  List todo = [];
  Future get()async{
    final response = await http.get(Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10'));
    print(response.statusCode);
    if(response.statusCode ==200){
      final datalist = jsonDecode(response.body);
      print(datalist);
      final data = datalist['items'];
      setState(() {
       todo = data;
      });
    }
  }

  Future delete(String id)async{
    final response = await http.delete(Uri.parse('https://api.nstack.in/v1/todos/$id'));
    if(response.statusCode ==200){
      get();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('TooDoo')),
      ),
      body: ListView.builder(
        itemCount: todo.length,
          itemBuilder: (context,index){
          final task = todo[index];
          final id = task['_id'];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text(task['description']),
            trailing: IconButton(
              onPressed: (){
                delete(id);
              },
              icon: Icon(Icons.delete),
            ),
          );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Alert'),
                  content: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        TextField(
                          controller: title,
                          decoration: InputDecoration(
                              hintText: 'Type'
                          ),
                        ),
                        TextField(
                          controller: desc,
                          decoration: InputDecoration(
                              hintText: 'Type'
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: (){
                          post();
                          Navigator.pop(context);
                          title.clear();
                          desc.clear();
                        },
                        child: Text('Ok')
                    )
                  ],
                );
              }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


