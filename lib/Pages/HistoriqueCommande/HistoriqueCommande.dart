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
  String selectedFilter = "Toutes";

  // ------------------------------------------------------------
  // 🔥 AJOUT : liste filtrée
  // ------------------------------------------------------------
  List<dynamic> listFiltre = [];

  @override
  void initState() {
    super.initState();

    // Initialisation de la liste filtrée
    listFiltre = HistoriqueCommande;
  }

  // ------------------------------------------------------------
  // 🔥 AJOUT : Convertir statut API → texte affichable
  // ------------------------------------------------------------
  String convertStatut(String statutAPI) {
    if (statutAPI.toLowerCase() == "pending") return "En attente";
    if (statutAPI.toLowerCase() == "failed") return "Annulé";
    return "Succès";
  }

  // ------------------------------------------------------------
  // 🔥 AJOUT : Appliquer le filtre
  // ------------------------------------------------------------
  void appliquerFiltre(String filtre) {
    setState(() {
      selectedFilter = filtre;

      if (filtre == "Toutes") {
        listFiltre = HistoriqueCommande;
      } else {
        listFiltre =
            HistoriqueCommande.where((cmd) {
              return convertStatut(cmd["statut"]) == filtre;
            }).toList();
      }
    });
  }

  // ------------------------------------------------------------
  // 🔥 AJOUT : Widget barre des filtres
  // ------------------------------------------------------------
  Widget barreFiltres() {
    final List<String> filtres = ["Toutes", "En attente", "Succès", "Annulé"];

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filtres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = filtres[index];
          final bool isSelected = (item == selectedFilter);

          return GestureDetector(
            onTap: () {
              appliquerFiltre(item); // <-- met à jour selectedFilter + liste
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => Dashboard()));
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: bodyContainer(constraints),
            bottomSheet: PiedPageIcone(),
          ),
        );
      },
    );
  }

  Widget bodyContainer(BoxConstraints constraints) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          AppBar(
            backgroundColor: CustomColors().backgroundAppkapi,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => logn(context),
            ),
            title: Text(
              "Historique des commande",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Row(
                children: [
                  Stack(
                    children: [
                      Icon(Icons.assignment, size: 50, color: Colors.white),
                      Positioned(
                        right: 10,
                        top: 0,
                        child: InkWell(
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                nombreCommande.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 18),
                  Padding(
                    padding: EdgeInsets.all(9),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset("assets/images/logo.jpeg"),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Bandeau décoratif
          Stack(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  image: DecorationImage(
                    image: AssetImage("assets/images/33.jpeg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
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
                      Colors.orange.shade600.withOpacity(0),
                      CustomColors().backgroundAppkapi,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  "$nombreCommande commandes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [Container(width: 150, height: 7, color: Colors.red)],
            ),
          ),

          SizedBox(height: 10),

          // ------------------------------------------------------------
          // 🔥 AJOUT : Barre des filtres
          // ------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: barreFiltres(),
          ),

          SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  // ------------------------------------------------------------
                  // 🔥 Liste filtrée
                  // ------------------------------------------------------------
                  child:
                      listFiltre.isEmpty
                          ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Aucune opération effectuée"),
                            ),
                          )
                          : Column(
                            children: List.generate(listFiltre.length, (index) {
                              final isSelected = index == selectedIndex;
                              final cmd = listFiltre[index];

                              return Column(
                                children: [
                                  // ---- CARTE DE LA COMMANDE ----
                                  Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.asset(
                                              "assets/images/commande.jpg",
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 10),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                buildInfoRow(
                                                  label: "Référence : ",
                                                  value: cmd["reference"],
                                                ),

                                                buildInfoRow(
                                                  label: "Frais livraison : ",
                                                  value: NumberFormat.currency(
                                                    locale: 'eu',
                                                    decimalDigits: 0,
                                                    symbol: devise,
                                                  ).format(
                                                    cmd["fraisLivraison"],
                                                  ),
                                                ),

                                                buildInfoRow(
                                                  label: "Montant total : ",
                                                  value: NumberFormat.currency(
                                                    locale: 'eu',
                                                    decimalDigits: 0,
                                                    symbol: devise,
                                                  ).format(
                                                    double.tryParse(
                                                          cmd["montantFinal"]
                                                              .toString(),
                                                        ) ??
                                                        0,
                                                  ),
                                                ),
                                                buildInfoRow(
                                                  label:
                                                      "Adresse de Livraison : ",
                                                  value:
                                                      cmd["adresseLivraison"] !=
                                                              null
                                                          ? cmd["adresseLivraison"]
                                                              .toString()
                                                          : "",
                                                ),
                                                buildInfoRow(
                                                  label: "Date : ",
                                                  value: cmd["date"].toString(),
                                                ),

                                                SizedBox(height: 5),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Statut : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),

                                                        Text(
                                                          convertStatut(
                                                            cmd["statut"],
                                                          ),
                                                          style: TextStyle(
                                                            color:
                                                                cmd["statut"]
                                                                            .toString()
                                                                            .toLowerCase() ==
                                                                        "pending"
                                                                    ? Colors
                                                                        .orangeAccent
                                                                    : cmd["statut"]
                                                                            .toString()
                                                                            .toLowerCase() ==
                                                                        "failed"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                          articlesCommandeDetail =
                                                              cmd["articles"];
                                                        });
                                                      },
                                                      child: Text(
                                                        "Détails 👉",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ---- AFFICHAGE DES ARTICLES ----
                                  if (isSelected)
                                    Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Détails commande",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        ...List.generate(articlesCommandeDetail.length, (
                                          a,
                                        ) {
                                          final article =
                                              articlesCommandeDetail[a];

                                          return Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          article["imageUrl"],
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (_, __) =>
                                                              CircularProgressIndicator(),
                                                      errorWidget:
                                                          (_, __, ___) => Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),

                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      buildInfoRow(
                                                        label: "Prix U : ",
                                                        value: NumberFormat.currency(
                                                          locale: 'eu',
                                                          decimalDigits: 0,
                                                          symbol: devise,
                                                        ).format(
                                                          double.tryParse(
                                                                article["prixUnitaire"]
                                                                    .toString(),
                                                              ) ??
                                                              0,
                                                        ),
                                                      ),
                                                      // buildInfoRow(
                                                      //   label: "Couleur : ",
                                                      //   value:
                                                      //       article["vcCouleur"],
                                                      // ),
                                                      buildInfoRow(
                                                        label:
                                                            article["vcCouleur"]
                                                                    .toString()
                                                                    .isNumericOnly
                                                                ? "Pointure : "
                                                                : "Taille : ",
                                                        value:
                                                            article["vcTaille"],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                ],
                              );
                            }),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({required String label, required String value}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  logn(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Dashboard()),
      );
    });
  }
}
