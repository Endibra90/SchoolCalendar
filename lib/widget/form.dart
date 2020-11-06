import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'grid.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:horario/model/cuadro.dart';

class FormWidget extends StatefulWidget {
  FormWidget({Key key, this.cuadro, this.lista, this.row, this.column})
      : super(key: key);
  Cuadro cuadro;
  List lista;
  int row;
  String column;
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final claseEdit = TextEditingController();
  final aulaEdit = TextEditingController();
  String claseUsuario = '';
  String aulaUsuario = '';
  String horaUsuario = '';
  int color = 0;
  @override
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<http.Response> sendExcel(List listdatos) async {
    http.get(
        'https://api.apispreadsheets.com/data/2375/?query=deletefrom2375*');
    return http.post(
      'https://api.apispreadsheets.com/data/2375/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, List>{
        'data': listdatos,
      }),
    );
  }

  changeCuadro() {
    setState(() {
      claseUsuario = claseEdit.text;
      horaUsuario = widget.lista[widget.row]['Horas'].toString();
      aulaUsuario = aulaEdit.text;
      widget.cuadro.clase = claseUsuario;
      widget.cuadro.hora = horaUsuario;
      widget.cuadro.aula = aulaUsuario;
      widget.cuadro.color = pickerColor;
      widget.lista[widget.row][widget.column] = claseUsuario +
          "|" +
          horaUsuario +
          "|" +
          aulaUsuario +
          "|" +
          pickerColor.toString();
    });
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String hora = widget.lista[widget.row]['Horas'].toString();
    return Scaffold(
        appBar: AppBar(
          title: Text('Añadir horario'),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: claseEdit,
                maxLength: 5,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.book),
                  hintText: 'Introduce la clase',
                  hintStyle: TextStyle(color: Colors.pink),
                  labelText: 'Clase',
                ),
              ),
              TextFormField(
                
                initialValue: hora,
                maxLength: 5,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.timer),
                ),
               
              ),
              TextFormField(
                controller: aulaEdit,
                maxLength: 3,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.room),
                  hintText: 'Introduce el aula',
                   hintStyle: TextStyle(color: Colors.pink),
                  labelText: 'Aula',
                ),
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        "Color:",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ))),
              Center(
                  child: RawMaterialButton(
                fillColor: pickerColor,
                padding: EdgeInsets.all(30),
                shape: CircleBorder(),
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("¡Elige un color!"),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Seleccionar'),
                            onPressed: () {
                              setState(() => currentColor = pickerColor);

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
                },
              )),
              Center(
                  child: Container(
                      margin: EdgeInsets.all(40),
                      child: new RaisedButton(
                        splashColor: Colors.white,
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(fontSize: 17),
                        ),
                        color: Colors.pink,
                        onPressed: () {
                          changeCuadro();
                          sendExcel(widget.lista);
                          Navigator.of(context).pop();
                          main();
                        },
                      ))),
            ],
          ),
        )));
  }
}
