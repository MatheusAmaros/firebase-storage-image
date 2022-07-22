import 'dart:io';

import 'package:camera_app/homePage.view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PreviewPageNetwork extends StatelessWidget {
  String teste;
  PreviewPageNetwork({Key? key, required this.teste}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: Stack(
            children: [
              Positioned.fill(
                
                child:Image.network(
                  teste,
                  fit: BoxFit.cover,
                ) 
              ),
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
                          icon:Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },),
                      )
                      ,
                    ),
                  )
                ],
              )
              ],
          ))
        ],
      ),
    );
  }
}