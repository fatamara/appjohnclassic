import 'dart:async';

import 'package:flutter/material.dart';
import 'package:johnclassic/Pages/Connexion/Connexion.dart';
import 'package:johnclassic/Pages/res/CustomColors.dart';
import 'package:video_player/video_player.dart';

import 'HELPER/Utils.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Charger la vidéo
    _controller = VideoPlayerController.asset('assets/images/videoJohn.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); //ici je lance la lecture de la video
        _controller.setLooping(false); // j'empeche de  répéter la vidéo
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // Utiliser le temps de la vidéo pour naviguer
          Future.delayed(Duration(seconds: 17), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Connexion()));
          });
        });
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();  // Libérer les ressources de la vidéo à la fin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Vidéo en arrière-plan
          Positioned.fill(
            child: VideoPlayer(_controller),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.9,
              child:  Utils().elevatedButtonIosAndroid(
                  onPressed: () {
                    _controller.pause();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Connexion()),
                    );
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          CustomColors().backgroundAppkapi),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(0),
                          )
                      )
                      )
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(13),
                    child: Center(
                      child: Text("Continuer"),
                    ),
                  ),
                  borderRadiusIOS: BorderRadius.circular(23),
                  colorIOS: CustomColors().backgroundColorYellow),
          )
        ],
      ),
    );
  }
}
