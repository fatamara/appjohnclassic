import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:johnclassic/Pages/HELPER/PiedPageIcone.dart';
import 'package:johnclassic/Pages/Panier/MonPanier.dart';

import '../Dashboard/Dashboard.dart';
import '../HELPER/NetworkCheck.dart';
import '../HELPER/Utils.dart';
import '../globals.dart';
import '../res/CustomColors.dart';



class Paiementarticle extends StatefulWidget {
  @override
  _PaiementarticleState createState() => _PaiementarticleState();
}

class _PaiementarticleState extends State<Paiementarticle> {

  TextEditingController numeroPaiement=TextEditingController();
  TextEditingController montantTotal=TextEditingController();
  final keyForm = GlobalKey<FormState>();
  bool OM=false;
  bool mobile=false;
  bool paiementLivraison=true;
  var modepaiement;



  Widget _buildButtonPaiement(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
     setState(() {

       montantTotal.text=MontantTotalAchat.toString();
      if(modepaiement.toString()=="3"){
        loaderAddCommande(context);
      }
      else{
        // modalPaiement(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 20,
            content: Row(
              children: [
                Icon(Icons.info,color: Colors.white,),
                Text("  Mode de paiement bientôt disponible !")
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }


     });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: EdgeInsets.all(10),
      child: Container(
        width:constraints.maxWidth<600?
        130:130,
        height: 35,
        decoration: BoxDecoration(
          color:  CustomColors().backgroundAppkapi,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(

          child:
          modepaiement.toString()=="3"?Text(
            'Commander',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:  Colors.white ,
            ),
          ):
          Text(
            'Payer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:  Colors.white ,
            ),
          ),
        ),
      ),),
    );
  }


  @override
  void initState() {

    OM=false;
    mobile=false;
    paiementLivraison=true;
    // Recherche l'index de "livraison"
    for (int i = 0; i < modePaiement.length; i++) {
      if (modePaiement[i]['vcMode'].toString().toLowerCase().contains("livraison")) {
        selectedModeIndex = i;
        modepaiement=modePaiement[i]['id'].toString();
        print("la valeur par defaut est ");
        print(modepaiement);
        break;
      }
    }
    super.initState();
  }

  @override



  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Monpanier()));
            return true; // Ensure this is true to intercept back navigation
          },
          child: Scaffold(
            backgroundColor:Colors.white,
            body:bodyContainer(constraints),
            bottomSheet:Container(
              color: Colors.white,
              height: constraints.maxWidth<=600?260:210,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10),
                    child:  Container(
                      width: MediaQuery.of(context).size.width*1.0,
                      height:  constraints.maxWidth<=600?150:120,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(
                        child:

                        Column(
                          children: [
                            Container(
                              width:MediaQuery.of(context).size.width*0.8,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Montant Achat :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  Text(NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                      .format(montantTotalPanier),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),)
                                ],
                              ),
                            ),
                            SizedBox(
                                width:MediaQuery.of(context).size.width*0.8,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Frais de livraison :",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),),
                                    Text(NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                        .format(montantLivraison),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),)
                                  ],
                                ),
                            ),
                            SizedBox(
                              width:MediaQuery.of(context).size.width*0.8,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Montant Total :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  Text(NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                      .format(MontantTotalAchat),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                            //Paiement
                            _buildButtonPaiement(constraints)

                          ],
                        )

                      ),
                    ),),
                  const Divider(),
                  PiedPageIcone(),

                ],
              ),
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
            title:  constraints.maxWidth<=600?
            Text("Univers de la sape JOHN CLASSIC",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),):
            Text("Univers de la sape d'ici et d'ailleurs" ,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),

            ),
            actions: [
              Builder(
                builder: (BuildContext context1) {
                  return  Row(
                    children: [
                    Icon(Icons.payment,size: 50,color: Colors.white,),

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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  image: const DecorationImage(
                      image: AssetImage("assets/images/33.jpeg"),
                      fit: BoxFit.cover,
                      opacity: 5.0
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(

                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade600.withOpacity(0.0),
                      CustomColors().backgroundAppkapi,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),


            ],
          ),

          const SizedBox(height: 10,),

          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                    size: 25,
                  color: Colors.red,),
                  Text("Shopping Adresse",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(2),
            child:
            Stack(
              children: [
                Column(
                  children: [
                    Card(
                      elevation: 10,
                      color: Colors.white,
                      child:IntrinsicHeight(
                        child:  Row(
                          children: [
                            Container(
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.all(Radius.circular(10))
                               ),
                                padding: EdgeInsets.all(5),
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset("assets/images/john.jpeg",
                                    width: 90,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),

                                )
                            ),
                            const VerticalDivider(),
                            Column(
                              children: [
                                Container(
                            width: MediaQuery.of(context).size.width*0.65,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("JOHN CLASSIC PREMIUN  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ],
                                  ),
                                ),
                                Container(

                                  width: MediaQuery.of(context).size.width*0.65,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                        width: MediaQuery.of(context).size.width*0.65,
                                        child: Text("Guinée Conakry Sangoyah Pharmacie",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.65,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Contact : ",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.42,
                                        child: Text("+224 629-65-79-72/621-56-08-79",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.65,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Email : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.42,
                                        child: Text("johnclassic224@gmail.com",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )


                              ],
                            ),

                          ],
                        ),
                      ),

                    ),
                  ],
                ),
              ],
            ),),
          const SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.car_crash,
                    size: 40,
                    color: Colors.red,),
                  Text(" Mode de Livraison ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold

                    ),),
                ],
              )
          ),
          const Divider(),
          const SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(Icons.payment,
                    size: 40,
                    color: Colors.red,),
                  Text(" Mode de Paiement ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold

                    ),),
                ],
              )
          ),
          const Divider(),
          Padding(padding: const EdgeInsets.all(5),
            child:
            Stack(
              children: [

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                    children: List.generate(modePaiement.length, (index) {
                      final mode = modePaiement[index];

                      // Image en fonction du type
                      String imagePath;
                      if (mode['vcMode'].toLowerCase().contains("orange")) {
                        imagePath = "assets/images/e-police_Icon_APP-orange-money-2.png";
                      } else if (mode['vcMode'].toLowerCase().contains("mobile")) {
                        imagePath = "assets/images/e-police_Icon_APP-mtn-momo-2.png";
                      } else {
                        imagePath = "assets/images/livraisonMode.jpg"; // remplace par une image par défaut
                      }

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedModeIndex = index;
                            modepaiement=modePaiement[index]['id'].toString();
                            print(modepaiement);
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: selectedModeIndex == index ? Colors.green : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    imagePath,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child:
                                mode['vcMode'].toString().contains("livraison")==true?
                                Text(
                                  "A la Livraison",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ):
                                Text(
                                  mode['vcMode'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],

                          ),
                        ),
                      );
                    }),
                  ),
                ),


              ],
            ),),
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
        MaterialPageRoute(builder: (context) => Monpanier()),
      );
    });
  }

  void modalPaiement(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            children: [
              Container(
                width: 220,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/30.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),

              ),
              Positioned(
                left: 50,
                  top: 12,
                  child: Padding(padding: EdgeInsets.all(9),
                child: ClipRRect(
                  borderRadius:BorderRadius.all(Radius.circular(30)),
                  child: Image.asset("assets/images/logo.jpeg",
                  width: 100,height: 70,),
                ),))
            ],
          ),
          backgroundColor: Colors.white, // Couleur de fond du modal
          content:Text(""),
          actions: <Widget>[
            Form(
              key:keyForm,
              child:Column(

                children: [
                  OM==true?
                  Row(
                    children: [Text("Paiement Orange Money")],
                  ):
                  paiementLivraison==true?
                  Row(
                    children: [
                      Text("Paiement à la livraison",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ):
                  Row(
                    children: [
                      Text("Paiement Mobile Money")
                    ],
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    controller: montantTotal,
                    keyboardType: TextInputType.number,
                    maxLength: 40,
                    enabled: false,  // Désactive le champ de texte
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      disabledBorder: OutlineInputBorder(  // Bordure lorsqu'il est désactivé
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "",
                      counterText: '',
                      label: const Text("Montant Total *"),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      isDense: true,
                      suffixText: "GNF",
                      suffixStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: (String phone) {},
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Veuillez saisir le montant";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    controller: numeroPaiement,
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    enabled: true,  // Désactive le champ de texte
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      disabledBorder: OutlineInputBorder(  // Bordure lorsqu'il est désactivé
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "---",
                      counterText: '',
                      label: const Text("Numéro de telephone*"),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      isDense: true,
                      suffixStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: (String phone) {},
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez saisir votre numéro.";
                      } else if (val.length < 9) {
                        return "Le numéro doit contenir 9 chiffres.";
                      }
                      else if (val.startsWith("6")!=true) {
                        return "Le numéro est invalide.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors().backgroundColorAll),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Annuler",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600),
                        onPressed: (){
                          if(keyForm.currentState!.validate()){
                            loaderAddCommande(context);
                          }
                        },
                        child: const Text("Valider",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                      )
                    ],
                  )
                ],
              ),),

          ],
        );
      },
    );
  }



  NetworkCheck networkCheck = NetworkCheck();
  loaderAddCommande(BuildContext context){
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
   print("***********le contenu de ma liste *****************");
   print(resultatFinalId);

    final String produitsEncoded = Uri.encodeComponent(jsonEncode(resultatFinalId));
    print(produitsEncoded);
    print(jsonEncode(resultatFinalId));

    addCommande(
        modePaiement: modepaiement,
        produitCommande:produitsEncoded,
        promo:"",
        montantTotal:MontantTotalAchat,

    );

  }
  addCommande({required modePaiement,required produitCommande,required promo,required montantTotal}) async {
    print("$baseUrl&task=addCommande&idUsersConnect=${dataResponse['id']}&idModePaiement=$modePaiement&produits="+produitCommande+"&montantTotal="+montantTotal.toString()+"&promo="+promo);

    try {
      networkCheck.checkInternet((isNetworkPresent) async {
        if (!isNetworkPresent) {
          Future.delayed(Duration(seconds: 3), () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop(); // Fermer le dialogue
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 20,
                content: Text("Echec de connexion à internet"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );

          });

          return;
        } else {
          print("mon tableau est ");
          print(produitCommande);

          http.Response response;
          response = await http.get(Uri.parse("${"$baseUrl&task=addCommande&idUsersConnect=${dataResponse['id']}&idModePaiement=$modePaiement&produits="+produitCommande}&montantTotal=$montantTotal&promo="+promo)
          );



          var jsonResponse = json.decode(response.body);

          if (jsonResponse["status"] == 200) {

            Future.delayed(Duration(seconds: 3), () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(); // Fermer le dialogue
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 20,
                  content: Text("Votre commandé a été lancé  avec succès. Le Gestionnaire vous contactera pour la livraision et le paiement Merci! "),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                monPanier.clear();
                resultatFinalId.clear();
                nombreArticlePanier = monPanier.length;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              });


            });

          }
          else {
            Future.delayed(Duration(seconds: 3), () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(); // Fermer le dialogue
              }
              //
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 20,
                  content: Text(jsonResponse["message"]),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );

            });
          }
        }
      });
    } on SocketException catch (_) {
      Future.delayed(Duration(seconds: 3), () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Fermer le dialogue
        }
        //
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 20,
            content: Text("Echec de connexion avec le serveur"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

      });
    }
  }
}


int selectedModeIndex = 1;

class ModePaiement {
  final int id;
  final String vcMode;
  final int btEnabled;
  ModePaiement({required this.id, required this.vcMode, required this.btEnabled});
}