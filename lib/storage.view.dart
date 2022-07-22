import 'package:camera_app/previewPageNetwork.view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImages();
  }

  loadImages() async{
    refs = (await storage.ref('images').listAll()).items;
    for (var ref in refs){
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() {
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
      ? const Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(24),
        child: arquivos.isEmpty
        ? const Center(
          child: Text('Não há imagens ainda')
        
        )
        :GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: arquivos.length,
            itemBuilder: (context, int index){
              return InkWell(
                  
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreviewPageNetwork(teste: arquivos[index])),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      
                      arquivos[index],
                      fit: BoxFit.cover,
                      
                    ),
                  ),
                );
            }
          ),

        )
    );
  }
}