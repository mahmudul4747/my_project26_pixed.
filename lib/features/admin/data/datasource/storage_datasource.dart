import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';



class StorageDatasource {


  final FirebaseStorage _storage =
      FirebaseStorage.instance;



  Future<String> uploadProductImage(
      File image
      ) async {


    final fileName =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString();



    final ref =
    _storage
        .ref()
        .child(
        "products/$fileName.jpg"
    );



    await ref.putFile(image);



    final url =
    await ref.getDownloadURL();



    return url;


  }



}