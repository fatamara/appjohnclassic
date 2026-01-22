import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import 'Pages/Accueil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Accueil(),
      builder: EasyLoading.init(), // Toujours présent, compatible
    ),
  );
}
