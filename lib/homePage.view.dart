import 'dart:io';

import 'package:camera_app/previewPage.view.dart';
import 'package:camera_app/storage.view.dart';
import 'package:camera_app/widgets/Anexo.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  File? teste;
  HomePage({Key? key, this.teste}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? arquivo;
  final picker = ImagePicker();
  bool uploading = false;
  double total = 0;
  
  Future<UploadTask> Upload() async{
    try{
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      return storage.ref(ref).putFile(widget.teste!);
    }on FirebaseException catch (e){
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future getFileFromGallery() async{
    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        widget.teste =  File(file.path);
      });
    }
  }
  showPreview(arquivo) async{
    
    File? arq = await Navigator.push(
                      context,  // error
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return PreviewPage(teste: arquivo); 
                        },
                      ),
                    );
    if(arquivo != null){
      setState(() {
        arquivo = arquivo;
        Navigator.pop(context);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(widget.teste != null)...[
               
               ElevatedButton.icon(
              onPressed: () async
              {
                UploadTask task = await Upload();
                task.snapshotEvents.listen((TaskSnapshot snapshot) async {
                  if(snapshot.state == TaskState.running){
                    setState(() {
                      uploading = true;
                      total = ((snapshot.bytesTransferred / snapshot.totalBytes) * 100);
                    });
                  }else if(snapshot.state == TaskState.success){
                    setState(() {
                      uploading = false;
                    });

                  }
                });
              },
              
              icon: Icon(Icons.upload), 
              label: Padding(
                padding: const EdgeInsets.all(16),
                child: uploading
                ? Text('${total.round()}%')
                : const Text('Upload'),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                
                textStyle: TextStyle(
                  fontSize: 18,
                )
              ),
              ),
              SizedBox(height: 30,),
              Anexo(arquivo: widget.teste!),
              SizedBox(height: 30,),
            ],
             
            
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        buttonSize:  Size(70, 70),
        spaceBetweenChildren: 20,
        spacing: 20,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera),
            label: "Camera",
            onTap: (){
              Navigator.push(
                        context,  // error
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return CameraCamera(onFile: (arquivo) => showPreview(arquivo));
                          },
                        ),
                      );
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.image),
            label: "Galeria",
            onTap: (){
              getFileFromGallery(); 
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.cloud),
            label: "Galeria Nuvem",
            labelStyle: TextStyle(
              color: Colors.white
            ),
            labelBackgroundColor: Color.fromARGB(255, 121, 0, 169),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoragePage()),
                );
            }
          )
        ],
      ) ,
      /*
      FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),*/
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
          data: IconThemeData(color:Theme.of(context).colorScheme.onPrimary),
          child:Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: (){

                },
                 icon: const Icon(Icons.list)
                ), 
                
              ],
            ),
          )
        ),
      ),
    );
  }
}