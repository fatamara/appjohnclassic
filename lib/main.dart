
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

import 'Pages/Accueil.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialBinding: NetworkBinding(),
        // home: TextRecognitionScreen(),
        home: Accueil(),
        builder: EasyLoading.init(),
      )
  );
}




