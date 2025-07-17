import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:johnclassic/Pages/Connexion/Connexion.dart';
import 'package:johnclassic/Pages/Panier/MonPanier.dart';
import 'package:johnclassic/Pages/Vetements/Vetement.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../Assistance.dart';
import '../Decor/Decor.dart';
import '../HELPER/PiedPageIcone.dart';
import '../HELPER/Utils.dart';
import '../MonProfil.dart';
import '../Services/Api.dart';
import '../globals.dart';
import '../res/CustomColors.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin, RouteAware {

  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String? selectedService;
  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>(debugLabel: 'GlobalFormKey Dash ');
  bool _isLoading = false;
  double prixPromoArticle=0;

  @override
  void initState() {
    ApiService().getListeArticle();
    ApiService().getListeModePaiement();
    mesArticlesFiltrer=mesArticles;
    print('le contenu filtrer est');
    print(mesArticlesFiltrer);

    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _controller = VideoPlayerController.asset('assets/images/JohnClassic.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _fadeController.forward();
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _fadeController.reset();
      _fadeController.forward();
    });
  }

  void _showLoader() {
    setState(() {
      _isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: AnimatedProgressBar(
              width: 200,
              height: 12,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }

  void _hideLoader() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Utils().animationSynchronized(
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              drawer: Drawer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CustomColors().backgroundAppkapi.withOpacity(0.95),
                        CustomColors().backgroundAppkapi.withOpacity(0.85),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          "${dataResponse['vcPrenom']} ${dataResponse['vcNom']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        accountEmail: Text(
                          dataResponse['vcMsisdn'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        currentAccountPictureSize: const Size(50, 50),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/logo.jpeg",
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomColors().backgroundColorAll,
                              CustomColors().backgroundColorAll.withOpacity(0.85),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: const Text(
                          'A propos',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.security, color: Colors.white),
                        title: const Text(
                          'Conditions d\'utilisation',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.help_center_outlined, color: Colors.white),
                        title: const Text(
                          'Assistance',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Assistance(title1: "Assistance")),
                          );
                        },
                      ),
                      const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: const Text(
                          'Mon Profil',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MonProfil()),
                          );
                        },
                      ),
                      const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.login, color: Colors.redAccent),
                        title: const Text(
                          'Déconnexion',
                          style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),
                        ),
                        onTap: () => showAlertDialogDeconnexion(context),
                      ),
                    ],
                  ),
                ),
              ),

              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Utils().animationContentTop(context: context, child: header()),
                    Expanded(
                      child: Utils().animationContentTop(
                        context: context,
                        child: Skeletonizer(
                          enabled: false,
                          child: body(constraints),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Utils().animationContentBottom(
                context: context,
                child: const PiedPageIcone(),
              ),
            ),
          ),
        );
      },
    );
  }

  Container header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: CustomColors().backgroundAppkapi.withOpacity(0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text("JOHN CLASSIC.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    color: Colors.white,
                    child: Icon(Icons.home, color: Colors.black),
                  ),
                ),
                VerticalDivider(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      value: selectedService,
                      hint: const Text("Services", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService = newValue;
                          if(selectedService=="Boutique"){
                            logn(context,chemin: 1);
                          }
                          else if(selectedService=="Décoration"){
                            logn(context,chemin: 2);
                          }
                          else if(selectedService=="Immobilier"|| selectedService=="Coiffure"){

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 20,
                                content:Row(
                                  children: [
                                    Icon(Icons.info,color: Colors.white,),
                                    Text("  Service bientôt disponible 🫣!")
                                  ],
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        });
                      },
                      items: <String>['Boutique', 'Décoration', 'Immobilier', 'Coiffure']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.black)
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                VerticalDivider(color: Colors.white),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                InkWell(
                  onTap:(){
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(color: Colors.white, child: Text("🧑🏾", style: TextStyle(fontSize: 15))),
                  ),
                )
                ,
               InkWell(
                 onTap:(){
                   if(nombreArticlePanier.toString()=="0"){
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         elevation: 20,
                         content:Row(
                           children: [
                             Icon(Icons.info,color: Colors.white,),
                             Text("  Votre Panier est vide  🫣!")
                           ],
                         ),
                         backgroundColor: Colors.red,
                         duration: Duration(seconds: 3),
                       ),
                     );
                   }
                   else{
                     Navigator.of(context).pushReplacement(
                       MaterialPageRoute(builder: (context) => Monpanier()),
                     );
                   }
                 },
                 child:  Stack(
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
                 ),
               )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView body(BoxConstraints constraints) {
    int nbColonnes = constraints.maxWidth <= 600 ? 2 : 3;
    int nbGroupes = (mesArticlesFiltrer.length / nbColonnes).ceil();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            child: _controller.value.isInitialized ? VideoPlayer(_controller) : Container(),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            elevation: 10,
            child: Container(
              height: 100,
              padding: constraints.maxWidth <= 600
                  ? const EdgeInsets.symmetric(horizontal: 2)
                  : const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 10),
                children: [
                  containerService(constraints, imageService: "assets/images/Boutik.png", textService: "Boutique", chemin: 1),
                  containerService(constraints, imageService: "assets/images/petit.png", textService: "Décoration", chemin: 2),
                  containerService(constraints, imageService: "assets/images/immo.png", textService: "Immobilier", chemin: 3),
                  containerService(constraints, imageService: "assets/images/coiffurec.jpg", textService: "Coiffure", chemin: 4),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Votre look, notre passion.! 💪🏼",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold

                    ),),
                ],
              )
          ),
          Padding(padding: EdgeInsets.only(left: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nouveautés 😍",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold

                    ),),
                  InkWell(
                    onTap: (){
                      logn(context,chemin: 1);

                    },
                    child: Text("voir plus .... 👉🏼 ",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold

                      ),),
                  ),
                ],
              )
          ),
          const SizedBox(height: 20,),
      mesArticlesFiltrer != null
          ? (mesArticlesFiltrer.isNotEmpty
          ? SizedBox(
        height: MediaQuery.of(context).size.height * 0.54,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: nbGroupes,
          itemBuilder: (context, groupeIndex) {
            int start = groupeIndex * nbColonnes;
            int end = (start + nbColonnes > mesArticlesFiltrer.length)
                ? mesArticlesFiltrer.length
                : start + nbColonnes;
            List<dynamic> articlesGroupe = mesArticlesFiltrer.sublist(start, end);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  children: articlesGroupe.asMap().entries.map((entry) {
                    int index = entry.key;
                    var article = entry.value;

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 500 + (index * 100)),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              dataIdCouleurAndCouleur = article["couleurs"];
                              dataidTailleAndTaille = article["tailles"];
                              idProduitPanier = int.parse(article["id"].toString());
                              print("idProduitPanier");
                              print(idProduitPanier.runtimeType);

                              prixPromoArticle = calculerPrixAvecPromo(
                                article["prix"].toString(),
                                article["promo"].toString(),
                              );
                            });

                            showDialog(
                              context: context,
                              builder: (_) => ZoomDialog(
                                description: article["description"].toString(),
                                // prix:prixPromoArticle.toStringAsFixed(0),
                                  prix:article["prix"].toString(),
                                viewNombre: article["QuanttiteDisponible"].toString(),
                                imageArticle: article["image"].toString(),
                                categorie: article["categorie"].toString(),
                                couleur: article["couleurs"],
                                taille: article["tailles"],
                                idProduit: article["id"],
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              // ... ton widget Card ici inchangé ...
                              Card(
                                elevation: 1,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: constraints.maxWidth <= 600
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width * 0.3,
                                  height: constraints.maxWidth <= 600
                                      ? MediaQuery.of(context).size.width * 0.5
                                      : MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: article["image"].toString(),
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 120,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.grey.shade100,
                                                  child: Container(color: Colors.white),
                                                ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.error, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article["nomArticle"].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      priceWidget(article),
                                    ],
                                  ),
                                ),
                              ),
                              if (double.tryParse(article["promo"].toString()) != null)
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${article["promo"]}%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ),
            );
          },
        ),
      )
          : const Center(
        child: Icon(
            Icons.hourglass_empty,
            size: 40,
            color: Colors.grey
        ),
      )
      )
          : const Center(
        child: CircularProgressIndicator(),
      )

      ],
      ),
    );
  }
  //fonction de calcul du priux de promo s'il existe pour passer au panier
  double calculerPrixAvecPromo(String prixStr, String promoStr) {
    double prix = double.tryParse(prixStr) ?? 0;

    if (promoStr.isNotEmpty && promoStr != "null") {
      double? promo = double.tryParse(promoStr);
      if (promo != null) {
        return prix * (1 + promo / 100);
      }
    }

    return prix;
  }
  Widget containerService(BoxConstraints constraints, {required String imageService, required String textService, required int chemin}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          InkWell(
              onTap:(){
                if(chemin==1){
                  logn(context,chemin: chemin);
                }
                else if(chemin==2){
                  logn(context,chemin: chemin);
                }
                else if(chemin==3|| chemin==4){
                  print("je rentre bien 5555");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 20,
                      content:Row(
                        children: [
                          Icon(Icons.info,color: Colors.white,),
                          Text("  Service bientôt disponible 🫣!")
                        ],
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            child: Container(
              padding: EdgeInsets.all(2),
              width: 94,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage(imageService),
                  fit: BoxFit.fitHeight,
                ),
                boxShadow: [BoxShadow(color: Colors.transparent, blurRadius: 0, spreadRadius: 0)],
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 800),
            child: Text(textService,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
  Widget priceWidget(Map<String, dynamic> article) {
    double prix = double.tryParse(article["prix"].toString()) ?? 0;
    String promoStr = article["promo"].toString();

    if (promoStr.isNotEmpty && double.tryParse(promoStr) != null) {
      // Si promo existe, on calcule le prix après promo

      double promoPercent = double.parse(promoStr); // ex: 20 pour 20%
      double prixPromo = prix * (1 + promoPercent / 100);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormat.currency(
              locale: 'eu',
              symbol: devise,
              decimalDigits: 0,
            ).format(prix),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              decoration: TextDecoration.lineThrough, // prix barré
            ),
          ),
          Text(
            NumberFormat.currency(
              locale: 'eu',
              symbol: devise,
              decimalDigits: 0,
            ).format(prixPromo),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      // Pas de promo, on affiche juste le prix normal
      return Text(
        NumberFormat.currency(
          locale: 'eu',
          symbol: devise,
          decimalDigits: 0,
        ).format(prix),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }
  }

  logn(BuildContext context,{required chemin}){
    _showLoader();

    ApiService().getListeArticle();
    Future.delayed(Duration(seconds: 3), () {
      _hideLoader();

      // Naviguer vers Dashboard
      if(chemin==1){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Vetement()),
        );
      }
      else if(chemin==2){
        chargementImageDecor();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Decor()),
        );
      }
      else if(chemin==5){
        ApiService().getListeArticle();
      }
    });
  }
  Future<void> showAlertDialogDeconnexion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Annuler"),
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 4,
        shadowColor: Colors.redAccent.withOpacity(0.4),
        textStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
      ),
      onPressed: () async {
        Navigator.of(context).pop(); // Close dialog first

        EasyLoading.instance
          ..dismissOnTap = true
          ..userInteractions = false;
        EasyLoading.show(status: 'Déconnexion en cours...');

        try {
          // Sauvegarde temporaire des données sensibles
          // await prefs.setString("msisdnCache", prefs.getString('msisdn') ?? '');
          // await prefs.setString("pinCache", prefs.getString('pin') ?? '');
          // await prefs.setString("idCache", prefs.getString('id') ?? '');

          // // Suppression des données de session
          // await prefs.remove('msisdn');
          // await prefs.remove('pin');
          // await prefs.remove('id');
          // await prefs.remove('nom');
          // await prefs.remove('prenom');

          EasyLoading.dismiss();

          // Naviguer vers la page de connexion
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Connexion()),
          );
        } catch (e) {
          EasyLoading.dismiss();
          if (kDebugMode) {
            print("Erreur lors de la déconnexion : $e");
          }
          // Optionnel : afficher une erreur utilisateur
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de la déconnexion.")),
          );
        }
      },
      child: const Text("Déconnexion"),
    );

    Widget alert;

    if (Platform.isAndroid) {
      alert = AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Déconnexion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [cancelButton, continueButton],
      );
    } else {
      alert = CupertinoAlertDialog(
        title: const Text(
          "Déconnexion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        ),
        actions: [
          CupertinoDialogAction(
            child: cancelButton,
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: continueButton,
            onPressed: () async {
              Navigator.of(context).pop();
              // même logique que ci-dessus, ou extraire dans une fonction commune
            },
          ),
        ],
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => alert,
    );
  }
  chargementImageDecor() {
    // Liste temporaire pour ajouter les articles
    List<DecorJohn> DecorJohnToAdd = [
      DecorJohn(
        idDecor: 1,
        descriptionDescor:"Un design simple et lumunieux",
        imageDecor: "assets/images/DecorImage/decor7.jpg",

      ),
      DecorJohn(
        idDecor: 2,
        descriptionDescor:"✨ Minimaliste & Haut de gamme",
        imageDecor: "assets/images/DecorImage/decor8.jpg",

      ),
      DecorJohn(
        idDecor: 3,
        descriptionDescor:"✨ Élégant & sophistiqué",
        imageDecor: "assets/images/DecorImage/decor13.jpg",

      ),
      DecorJohn(
        idDecor: 4,
        descriptionDescor:"✨ Élégant & sophistiqué",
        imageDecor: "assets/images/DecorImage/decor10.jpg",

      ),
      DecorJohn(
        idDecor: 5,
        descriptionDescor:"✨ Naturel & éco-friendly",
        imageDecor: "assets/images/DecorImage/decor11.jpg",

      ),
      DecorJohn(
        idDecor: 6,
        descriptionDescor:"✨ Tendance & créatif",
        imageDecor: "assets/images/DecorImage/decor12.jpg",

      ),
      DecorJohn(
        idDecor: 7,
        descriptionDescor:"✨ Ambiance cocooning & chaleureuse",
        imageDecor: "assets/images/31.jpeg",

      ),
      DecorJohn(
        idDecor: 8,
        descriptionDescor:"✨ Ambiance cocooning & chaleureuse",
        imageDecor: "assets/images/DecorImage/decor6.jpg",

      ),
    ];

    // Ajout des articles dans mesArticles seulement si l'idArticle n'existe pas déjà
    for (var decor in DecorJohnToAdd) {
      // Vérification si l'ID de l'article existe déjà dans mesArticles
      bool existeDeja = malisteDecor.any((existingDecor) => existingDecor.idDecor == decor.idDecor);

      // Si l'article n'existe pas déjà, on l'ajoute à la liste
      if (!existeDeja) {
        malisteDecor.add(decor);
      } else {
        print('L\'article avec l\'id ${decor.idDecor} existe déjà');
      }
    }

    // Afficher la liste des articles après ajout
    print("La liste des articles :");
    malisteDecor.forEach((decor) {
      print('ID: ${decor.idDecor}, Description: ${decor.descriptionDescor}');
    });
  }
}


/// Animated Progress Bar Widget (loader)
class AnimatedProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const AnimatedProgressBar({
    Key? key,
    this.width = 150,
    this.height = 8,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            ),
          );
        },
      ),
    );
  }

}
