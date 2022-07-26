import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:camera_app/homePage.view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PreviewPageNetwork extends StatelessWidget {
  String teste;

  PreviewPageNetwork({Key? key, required this.teste}) : super(key: key);
  Future? verifica;
  Future createAlbum() async {
    var response = await Dio().post('http://192.168.0.18:4000/teste',
        data: {
          "path": teste,
        },
        options: Options(receiveTimeout: 500000, sendTimeout: 500000));

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                teste,
                fit: BoxFit.cover,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: FutureBuilder(
                            future: createAlbum(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                return Container(
                                  width: 200,
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data['PrimeiroDiagnostico']
                                            .toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        snapshot.data['SegundoDiagnostico']
                                            .toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            })),
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
