import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';
import 'package:johnclassic/Pages/res/CustomColors.dart';

class Pied extends StatelessWidget{
  const Pied({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5),
        color: Colors.black,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Copyright ",style: TextStyle(color: Colors.white),),
            const Icon(Icons.copyright,color:Colors.white,size:14),
            Text("${DateFormat('yyyy').format(DateTime.now())} | Made with ",style: const TextStyle(color: Colors.white),),
            const Icon(Icons.ac_unit,color:Colors.white,size:10),
            const Text(" by John-Classic",style: TextStyle(color: Colors.white),),
          ],
        ),
    );
  }

}