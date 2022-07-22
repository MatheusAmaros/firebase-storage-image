import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class Anexo extends StatelessWidget {
  final File arquivo;
  const Anexo({Key? key, required this.arquivo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Flexible(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10) ,bottomRight: Radius.circular(10),topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            child: Column(
              children: [
                
                Image.file(arquivo, fit: BoxFit.cover,height: 200,width: 200,),
              ],
            )
          )
        ),
      ),
    );
  }
}