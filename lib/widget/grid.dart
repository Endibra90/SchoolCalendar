import 'package:flutter/material.dart';
import 'package:horario/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'form.dart';
import 'package:horario/model/cuadro.dart';

class GridWidget extends StatefulWidget {
  GridWidget({Key key}) : super(key: key);

  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  var listaHoras;
  var listaContenedores = [];
  var contenedores = <Cuadro>[];
  void anadirContainer(int index) async {
    if (listaHoras != null) {
      for (int i = 0; i < index; i++) {
        contenedores = <Cuadro>[];
        for (int y = 0; y < 7; y++) {
          anadirClaseContenedor(i, y);
        }
        listaContenedores.add(contenedores);
      }
    }
    setState(() {});
  }

  void anadirClaseContenedor(int row, int column) {
    if (listaHoras[row][listaDias[column + 1]] != '') {
      var datosExcel = listaHoras[row][listaDias[column + 1]].split("|");
      String clase = datosExcel[0];
      String hora = datosExcel[1];
      String aula = datosExcel[2];
      String color = datosExcel[3];
      color = color.replaceAll('Color(', '');
      color = color.replaceAll(')', '');
      Color color2 = Color(int.parse(color));
      contenedores.add(Cuadro(clase, hora, aula, color2));
    } else {
      contenedores.add(Cuadro("", "", "", Colors.white));
    }
  }

  Future<List<dynamic>> apiRequest() async {
    final response =
        await http.get('https://api.apispreadsheets.com/data/2768/');
    if (response.statusCode == 200) {
      var datos = convert.jsonDecode(response.body);
      return datos['data'];
    }
  }

  void initState() {
    super.initState();
    changeList();
  }

  void changeList() async {
    listaHoras = await apiRequest();
    anadirContainer(listaHoras.length);
    setState(() {});
  }

  var listaDias = ['', 'L', 'M', 'X', 'J', 'V', 'S', 'D'];
  var listaColores = [50, 100, 200, 300, 400, 600, 700, 800, 900];
  @override
  Widget build(BuildContext context) {
    return Column(children: listaWidget());
  }

  List<Widget> listaWidget() {
    return <Widget>[
      if (listaHoras != null && listaContenedores != null) ...{
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.count(primary: false, crossAxisCount: 8, children: [
              for (int i = 0; i < listaDias.length; i++) ...{
                if (listaDias[i] == '') ...{
                  Container(
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      "Dias",
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold),
                    )),
                  )
                } else ...{
                  Container(
                    padding: EdgeInsets.all(18),
                    child: Text(listaDias[i]),
                    color: Colors.pink[listaColores[i]],
                  )
                }
              },
              for (int i = 0; i < listaHoras.length; i++) ...{
                Container(
                    color: Colors.pink[listaColores[i]],
                    child: Row(
                      children: [Text(listaHoras[i]['Horas'])],
                    )),
                for (int y = 0; y < 7; y++) ...{
                  if(listaHoras[i]['Horas']=='11:40' || listaHoras[i]['Horas']=='12:05')...{
                    InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.pink[100])),
                    ),
                  )
                  }else...{
                  InkWell(
                    child: Container(
                      child: Column(children: [
                        Text(listaContenedores[i][y].clase,style:TextStyle(color:Colors.white),),
                        Text(listaContenedores[i][y].aula,style:TextStyle(color:Colors.white),)
                      ]),
                      decoration: BoxDecoration(
                          color: listaContenedores[i][y].color,
                          border: Border.all(color: Colors.pink[100])),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                            opaque: true,
                            pageBuilder: (BuildContext context, _, __) {
                              return FormWidget(
                                  cuadro: listaContenedores[i][y],
                                  lista: listaHoras,
                                  row: i,
                                  column: listaDias[y + 1],
                                  );
                            }),
                      );
              
                    },
                  )}
                }
              }
            ])),
      } else ...{
        Center(
            child: Container(
                height: 280,
                width: 120,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator())))
      }
    ];
  }
}
