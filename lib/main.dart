// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'info.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Estudiantes> estudiantes = [];

  @override
  void initState() {
    loadEstudiantes();
    super.initState();
  }

  Future<String> readFirebase() async {
    final connectDB = await http.get(Uri.parse(
        'https://estudiantes-rest-api-default-rtdb.firebaseio.com/.json'));
    return connectDB.body;
  }

  Future loadEstudiantes() async {
    final String jsonLink = await readFirebase();
    final dynamic jsonRespuesta = json.decode(jsonLink);
    for (Map<String, dynamic> i in jsonRespuesta) {
      estudiantes.add(Estudiantes.fromJson(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Color.fromRGBO(41, 39, 46, 300),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                'Estudiantes',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: FutureBuilder(
                future: readFirebase(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    return ListView.builder(
                        itemCount: estudiantes.length,
                        itemBuilder: (context, index) {
                          var matricula = estudiantes[index].matricula;
                          var name = estudiantes[index].name;
                          var phone = estudiantes[index].phone;
                          var email = estudiantes[index].email;
                          var career = estudiantes[index].career;
                          var semester = estudiantes[index].semester;

                          return Container(
                            alignment: Alignment.center,
                            height: 90,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentInfo(
                                              matricula: matricula,
                                              semester: semester,
                                              name: name,
                                              phone: phone,
                                              email: email,
                                              career: career,
                                            )));
                              },
                              title: Text(
                                name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              subtitle: Text(career,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 138, 138, 138),
                                      fontSize: 12)),
                              leading: CircleAvatar(
                                  child: Text(
                                estudiantes[index].name.substring(0, 1),
                                style: const TextStyle(
                                    color: Color.fromARGB(247, 255, 255, 255)),
                              )),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          );
                        });
                  } else {
                    return Text('sds');
                  }
                }),
          ),
        ));
  }
}

class Estudiantes {
  String name = "";
  String matricula = "";
  String phone = "";
  String email = "";
  String semester = "";
  String career = "";
  Estudiantes(this.name, this.matricula, this.phone, this.email, this.semester,
      this.career);

  factory Estudiantes.fromJson(Map<String, dynamic> paredJson) {
    return Estudiantes(
        paredJson['name'],
        paredJson['matricula'],
        paredJson['phone'],
        paredJson['email'],
        paredJson['semester'],
        paredJson['career']);
  }
}
