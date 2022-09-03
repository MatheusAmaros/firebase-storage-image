import 'dart:io';
import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class HomePage extends StatefulWidget {
  File? teste;
  HomePage({Key? key, this.teste}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _image;
  late List _results;
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? arquivo;
  final picker = ImagePicker();
  bool uploading = false;
  double total = 0;

  Future createAlbum(File imagem) async {
    List<int> imageBytes = await imagem.readAsBytesSync();
    //String base64Image = base64Encode(imageBytes);
    print(imagem.path);
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.21:4000/imagem'));
    request.files.add(await http.MultipartFile.fromPath('imagem', imagem.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    Map valueMap = json.decode(response.body);
    return valueMap;

    /*
    
    var filename = imagem.path.split('/').last;
    FormData formData = new FormData.fromMap({"imagem": imagem.path});
    var response = await Dio().post('http://192.168.163.248:4000/imagem',
        data: formData,
        options: Options(receiveTimeout: 500000, sendTimeout: 500000));
    print("base64Image");
    return response.data;*/
  }

  Future<UploadTask> Upload() async {
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';

      return storage.ref(ref).putFile(widget.teste!);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future getFileFromGallery() async {
    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        widget.teste = File(file.path);
      });
    }
  }

  showPreview(arquivo) async {
    File? arq = await Navigator.push(
      context, // error
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PreviewPage(teste: arquivo);
        },
      ),
    );
    if (arquivo != null) {
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
            if (widget.teste != null) ...[
              Container(
                width: 500,
                height: 500,
                child: FutureBuilder(
                    future: createAlbum(widget.teste!),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Text(
                            snapshot.data['PrimeiroDiagnostico'].toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Anexo(arquivo: widget.teste!),
              SizedBox(
                height: 30,
              ),
            ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        buttonSize: Size(70, 70),
        spaceBetweenChildren: 20,
        spacing: 20,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera),
              label: "Camera",
              onTap: () {
                Navigator.push(
                  context, // error
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CameraCamera(
                          onFile: (arquivo) => showPreview(arquivo));
                    },
                  ),
                );
              }),
          SpeedDialChild(
              child: Icon(Icons.image),
              label: "Galeria",
              onTap: () {
                getFileFromGallery();
              }),
          SpeedDialChild(
              child: Icon(Icons.cloud),
              label: "Galeria Nuvem",
              labelStyle: TextStyle(color: Colors.white),
              labelBackgroundColor: Color.fromARGB(255, 121, 0, 169),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoragePage()),
                );
              })
        ],
      ),
      /*
      FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),*/
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.install_desktop)),
                ],
              ),
            )),
      ),
    );
  }
}
