import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:johnclassic/Pages/Services/Api.dart';
import 'package:shimmer/shimmer.dart';

import 'package:johnclassic/Pages/HELPER/PiedPageIcone.dart';
import 'package:johnclassic/Pages/PaiementArticles/PaiementArticle.dart';

import '../Dashboard/Dashboard.dart';
import '../HELPER/Utils.dart';
import '../globals.dart';
import '../res/CustomColors.dart';



class Historiquecommande extends StatefulWidget {
  @override
  _HistoriquecommandeState createState() => _HistoriquecommandeState();
}

class _HistoriquecommandeState extends State<Historiquecommande> {


  final keyForm = GlobalKey<FormState>();
  int selectedIndex = -1;


  @override
  void initState() {

    super.initState();
  }

  @override



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
            body:bodyContainer(constraints),
            bottomSheet:PiedPageIcone(),

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
            Text("Historique des commande",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),),
            actions: [
              Builder(
                builder: (BuildContext context1) {
                  return  Row(
                    children: [
                      Stack(
                        children: [
                          Icon(Icons.assignment,size: 50,color: Colors.white,),
                          Positioned(
                            right: 10,
                            top: 0,
                            child:InkWell(
                              onTap: (){

                              },
                              child: Container(
                                width: 20,

                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red
                                ),
                                child:Center(
                                  child: Text(nombreCommande.toString(),
                                    style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ) ,),
                                ),
                              ),
                            ),

                          )
                        ],
                      )
                      ,
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
                  Text("$nombreCommande commandes",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold

                    ),),
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
          const SizedBox(height: 10,),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: constraints.maxHeight <= 600
                    ? MediaQuery.of(context).size.height * 0.5
                    : MediaQuery.of(context).size.height * 0.64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: HistoriqueCommande == null || HistoriqueCommande.isEmpty
                    ? const Center(child: Text("Aucune opération effectuée"))
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: HistoriqueCommande.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = index == selectedIndex;

                    return Column(
                      children: [
                        Card(
                          elevation: 10,
                          color: Colors.white,
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/commande.jpg",
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(),
                                Column(
                                  children: [
                                    buildInfoRow(
                                      label: "Réference  : ",
                                      value: HistoriqueCommande[index]["reference"],
                                    ),
                                    buildInfoRow(
                                      label: "Frais Livraison : ",
                                      value: NumberFormat.currency(
                                          locale: 'eu',
                                          decimalDigits: 0,
                                          symbol: devise)
                                          .format(HistoriqueCommande[index]["fraisLivraison"]),
                                    ),
                                    buildInfoRow(
                                      label: "Montant Total : ",
                                      value: NumberFormat.currency(
                                          locale: 'eu',
                                          decimalDigits: 0,
                                          symbol: devise)
                                          .format(double.tryParse(
                                          HistoriqueCommande[index]["montantFinal"])),
                                    ),
                                    buildInfoRow(
                                      label: "Date : ",
                                      value: HistoriqueCommande[index]["date"].toString(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      child: Row(
                                        children: [
                                          const Text("Statut : ",
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              Text(
                                                HistoriqueCommande[index]["statut"]
                                                    .toString()
                                                    .toLowerCase() ==
                                                    "pending"
                                                    ? "En attente"
                                                    : HistoriqueCommande[index]["statut"]
                                                    .toString()
                                                    .toLowerCase() ==
                                                    "failed"
                                                    ? "Annulé"
                                                    : "Succès",
                                                style: TextStyle(
                                                  color: HistoriqueCommande[index]["statut"]
                                                      .toString()
                                                      .toLowerCase() ==
                                                      "pending"
                                                      ? Colors.orangeAccent
                                                      : HistoriqueCommande[index]["statut"]
                                                      .toString()
                                                      .toLowerCase() ==
                                                      "failed"
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                    articlesCommandeDetail = HistoriqueCommande[index]["articles"];
                                                  });
                                                },
                                                child: const Text(
                                                  "         Détails .. 👉🏼 ",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 👉 Affichage des détails articles si sélectionné
                        if (isSelected)
                          Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("---------", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(" Détails commande ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text("  --------", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: articlesCommandeDetail.length,
                                itemBuilder: (context, artIndex) {
                                  final article = articlesCommandeDetail[artIndex];
                                  return Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: article["imageUrl"],
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.grey.shade100,
                                                  child: Container(
                                                    width: 70,
                                                    height: 70,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  width: 70,
                                                  height: 70,
                                                  color: Colors.grey[200],
                                                  child: const Icon(Icons.error, color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              buildInfoRow(
                                                label: "Prix U : ",
                                                value: NumberFormat.currency(
                                                  locale: 'eu',
                                                  decimalDigits: 0,
                                                  symbol: devise,
                                                ).format(double.tryParse(article["prixUnitaire"])),
                                              ),
                                              buildInfoRow(
                                                label: "Couleur : ",
                                                value: article["vcCouleur"],
                                              ),
                                              buildInfoRow(
                                                label: article["vcCouleur"].toString().isNumericOnly
                                                    ? "Pointure : "
                                                    : "Taille : ",
                                                value: article["vcTaille"].toString(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),


          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget buildInfoRow({required String label, required String value}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
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

}
