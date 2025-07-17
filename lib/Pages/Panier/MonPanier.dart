import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:johnclassic/Pages/HELPER/PiedPageIcone.dart';


import '../Dashboard/Dashboard.dart';
import '../HELPER/Utils.dart';
import '../PaiementArticles/PaiementArticle.dart';
import '../globals.dart';
import '../res/CustomColors.dart';



class Monpanier extends StatefulWidget {
  @override
  _MonpanierState createState() => _MonpanierState();
}

class _MonpanierState extends State<Monpanier> {


  final keyForm = GlobalKey<FormState>();


  //button de paiement
  Widget _buildButtonPaiement(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
       setState(() {
         MontantTotalAchat=montantTotalPanier+montantLivraison;
       });
        // Naviguer vers Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Paiementarticle()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width:constraints.maxWidth<600?
        130:130,
        height: 35,
        decoration: BoxDecoration(
          color:  Colors.black ,
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
          child: Text(
            'Payer maintenant',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:  Colors.white ,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    montantTotalPanier = monPanier.fold(
      0.0,
          (total, produit) => total + produit.prixTotal,
    );
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
            resizeToAvoidBottomInset: false,
            body:bodyContainer(constraints),
            bottomSheet:Container(
              height: constraints.maxWidth<=600?185:140,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10),
                  child:  Container(
                    width: MediaQuery.of(context).size.width*1.0,
                    height:  constraints.maxWidth<=600?80:50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child:
                          constraints.maxWidth<=600?
                          Column(
                         children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart,color: Colors.white,),
                              Column(
                                children: [
                                  Text(" Montant  Total ${NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                      .format(montantTotalPanier)}")
                                ],
                              )
                            ],
                          ),
                          //Paiement
                          _buildButtonPaiement(constraints)

                        ],
                      ):
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child:Row(
                                  children: [
                                    Icon(Icons.shopping_cart,color: Colors.white,),
                                    Text("Montant  Total ${NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                        .format(montantTotalPanier.toString())}")
                                  ],
                                ),
                              ),
                              _buildButtonPaiement(constraints)
                            ],
                          ),
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
                      Stack(
                        children: [
                          Icon(Icons.shopping_cart,size: 50,color: Colors.white,),
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
                                  child: Text(nombreArticlePanier.toString(),
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
                      CustomColors().backgroundAppkapi
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
                  Text("$nombreArticlePanier articles",
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
              child:
              Padding(padding: const EdgeInsets.all(2),
                child:
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight <= 600
                      ? MediaQuery.of(context).size.height * 0.42
                      : MediaQuery.of(context).size.height * 0.58,

                  decoration:const  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: FutureBuilder(
                    future: null, // Tu peux définir un vrai Future ici si nécessaire
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (monPanier == null || monPanier.isEmpty) {
                        return const Center(child: Text("Aucune opération effectuée"));
                      }
                      return AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: monPanier.length,
                          itemBuilder: (context, index) {
                            final item = monPanier[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: Duration(milliseconds: 100),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 10,
                                        color: Colors.white,
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              // Image
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: item.imageArticle,
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade300,
                                                      highlightColor: Colors.grey.shade100,
                                                      child: Container(
                                                        width: 90,
                                                        height: 90,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      width: 90,
                                                      height: 90,
                                                      color: Colors.grey[200],
                                                      child: const Icon(Icons.error, color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const VerticalDivider(),
                                              // Infos texte
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _infoRow("Catégorie", item.categorie, context),
                                                  _infoRow("Couleur", item.couleur, context),
                                                  _infoRow(
                                                    item.taille.isAlphabetOnly ? "Taille" : "Pointure",
                                                    item.taille,
                                                    context,
                                                  ),
                                                  _infoRow(
                                                    "Prix",
                                                    NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: devise)
                                                        .format(item.prixTotal),
                                                    context,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Boutons +/- Quantité
                                      Positioned(
                                        right: 10,
                                        top: 32,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  if (item.quantite > 1) {
                                                    item.quantite--;
                                                    _recalculerMontants();
                                                  }
                                                });
                                              },
                                            ),
                                            Text(item.quantite.toString(), style: TextStyle(fontSize: 20)),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  item.quantite++;
                                                  _recalculerMontants();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Supprimer
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _supprimerItem(item);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                            child: const Icon(Icons.remove, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );


                    },
                  ),

                ),)
          )
         ,
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        children: [
          Text("$label : ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  void _recalculerMontants() {
    // Recalcul du montant total du panier
    montantTotalPanier = monPanier.fold(
      0.0,
          (total, produit) => total + produit.prixTotal,
    );

    // Montant total achat = panier + livraison
    MontantTotalAchat = montantTotalPanier + montantLivraison;

    // Mise à jour des quantités dans resultatFinalId
    for (var item in resultatFinalId) {
      final panierItem = monPanier.firstWhere(
            (p) => p.idProduit == item['idProduit'],
        orElse: () => null as Produit,
      );

      if (panierItem != null) {
        item['quantite'] = panierItem.quantite;
      }
    }
  }
  void _supprimerItem(item) {
    monPanier.removeWhere((e) =>
    e.idProduit == item.idProduit &&
        e.idCouleur == item.idCouleur &&
        e.idTaille == item.idTaille

    );
    resultatFinalId.removeWhere((e) =>
    int.parse(e['idProduit'].toString()) == item.idProduit
    );
    montantTotalPanier = monPanier.fold(0.0, (total, produit) => total + produit.prixTotal);
    nombreArticlePanier = monPanier.length;

    print('*****La valeur apres suppression*****');
    if ((resultatFinalId?.isEmpty ?? true)) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Dashboard())
      );
    }
  }
  LoaderArticle(BuildContext context){
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
    });
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
