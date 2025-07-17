import 'dart:async';
import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';

import 'package:johnclassic/Pages/HELPER/PiedPageIcone.dart';
import 'package:johnclassic/Pages/PaiementArticles/PaiementArticle.dart';
import 'package:video_player/video_player.dart';

import '../Dashboard/Dashboard.dart';
import '../HELPER/Utils.dart';
import '../Panier/MonPanier.dart';
import '../globals.dart';
import '../res/CustomColors.dart';



class Decor extends StatefulWidget {
  @override
  _DecorState createState() => _DecorState();
}

class _DecorState extends State<Decor> {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final keyForm = GlobalKey<FormState>();




  @override
  void initState() {

    _controller = VideoPlayerController.asset('assets/images/pubJohnDecor.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(false);
        _fadeController.forward();
      });
    super.initState();
  }

  @override

  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Dashboard()));
            return true; // Ensure this is true to intercept back navigation
          },
          child: Scaffold(
            backgroundColor:Colors.white,
            resizeToAvoidBottomInset: false,
            body:bodyContainer(constraints),
            bottomSheet:Stack(
              children: [
                PiedPageIcone(),
              ],
            ),

          ),
        );
      },
    );
  }
  Widget bodyContainer(BoxConstraints constraints) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: CustomColors().backgroundAppkapi,

            elevation: 0,
            leading: IconButton(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 0.0, right: 0.0, bottom: 0.0),
              icon: const Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 35,
              ),
              tooltip: 'Comment Icon',
              onPressed: () {

                logn(context);

              },
            ),
            title:
            Text("Univers JOHN CLASSIC DECOR",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),)

            ,
            actions: [
              Builder(
                builder: (BuildContext context1) {
                  return  Row(
                    children: [

                      const  SizedBox(
                        height: 18,
                        child: VerticalDivider(
                            thickness: 1, width: 1, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Padding(padding: EdgeInsets.all(9),
                        child: ClipRRect(
                          borderRadius:BorderRadius.all(Radius.circular(10)),
                          child: Image.asset("assets/images/logo.jpeg",),
                        ),)

                    ],
                  );
                },
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.all(5),
                child: _controller.value.isInitialized ? VideoPlayer(_controller) : Container(),
              ),
              Positioned(
                right: -10,
                  bottom: 7,
                  child: Container(
                    width: 80,
                    height: 15,
                    color: Colors.white,
                  )
              )
            ],
          ),


          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text("✨ Élégant & Luxueux",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),),
                ],
              )
          ),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Text("Offrez à votre intérieur l'élégance qu'il mérite. Des pièces uniques pour une ambiance chic et intemporelle.",
                      style: TextStyle(

                          fontWeight: FontWeight.bold

                      ),),
                  ),
                ],
              )
          ),
          Padding(padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [Container(
                width: 100,
                height: 7,
                color:Colors.red,
              ),

              ],
            ),),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.phone,color: Colors.red,),
                  Flexible(
                    child: Text("Appelez-nous dès maintenant le 629657972 et benefissiez d'un renouveau de taille.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold

                      ),),
                  ),
                ],
              )
          ),
          const SizedBox(height: 10,),
          SingleChildScrollView(
              child:
              Padding(padding: const EdgeInsets.all(2),
                child:
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight <= 600
                      ? MediaQuery.of(context).size.height * 0.35
                      : MediaQuery.of(context).size.height * 0.5,

                  decoration:const  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(malisteDecor!=null){
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,

                            itemCount:malisteDecor.length,
                            itemBuilder: (context, index) {
                              return
                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 10,
                                          color: Colors.white,
                                          child:Container(
                                            height: MediaQuery.of(context).size.height*0.25,
                                              padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              image:  DecorationImage(
                                                image: ExactAssetImage(malisteDecor[index].imageDecor),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child:InkWell(
                                        onTap: (){

                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.white
                                          ),
                                          child:Text(malisteDecor[index].descriptionDescor),
                                        ),
                                      ),

                                    )

                                  ],
                                );
                            });
                      }
                      else {
                        return const Center(child:Text("Aucun opération effectuée"));
                      }
                    },
                    future: null,
                  ),
                ),)
          )
          ,
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  logn(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(); // Fermer le dialogue
      }
      // Naviguer vers Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }
  loadingPanier(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(); // Fermer le dialogue
      }
      // Naviguer vers Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Monpanier()),
      );
    });
  }
}
