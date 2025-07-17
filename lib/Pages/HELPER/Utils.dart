import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:johnclassic/Pages/Accueil.dart';
import 'package:johnclassic/Pages/Vetements/Vetement.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'dart:io';


import '../globals.dart';
import '../res/CustomColors.dart';


class Constants{
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 40;
}

class Utils {




  void nextPage({context,builder, required name}){
    Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (BuildContext context) => builder,
        )
    );
  }

  void nextPageWithoutBackStack({context,builder}){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => builder));
  }



  AppBar appBarCustom({required context,required title,required color,required iconsColor, required bool isBack}){
    return AppBar(
      backgroundColor: Colors.red[800],
      elevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
        icon: isBack ? const Icon(Icons.keyboard_backspace,color: Colors.white,size: 35,) : Image.asset(
          "assets/images/logo.jpeg",
          height: 30,
          width: 30,
        ),
        tooltip: 'Comment Icon',
        onPressed: () {
          if(isBack) {
            Navigator.pop(context);
          }
        },
      ),
      title: Center(
        child: Text(title,style: const TextStyle(color: Colors.white,fontSize: 15),),
      ),
      actions: [
        Builder(
          builder: (BuildContext context1) {
            return  Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'assets/images/logo.jpeg',
                width: 30,height: 30,
                // color: iconsColor ?? Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }

  String getDate({required date, required format}){
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getDateFormat({required date}){
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat.yMMMMEEEEd('fr_FR');
    final String formatted = formatter.format(now);
    return formatted;
  }

  bool isNumeric(String s) {
    try{
      if (s == null || s.isEmpty) {
        return false;
      }
      return double.tryParse(s) != null;
    }on Exception catch(_){
      return false;
    }
  }

  bool isInt(String s) {
    try{
      if (s == null || s.isEmpty) {
        return false;
      }
      return int.tryParse(s) != null;
    }on Exception catch(_){
      return false;
    }
  }

  notNetwork({message,context}) {
    showDialog(
      context: context,
      builder: (context1) {
        if(Platform.isAndroid) {
          return AlertDialog(
            title: const Center(child: Text('Information:'),),
            backgroundColor: Colors.white,
            content: IntrinsicHeight(
              child: Container(
                margin:const EdgeInsets.only(top: 10, bottom: 10),
                // height: 200,
                color: Colors.transparent,
                width: MediaQuery.of(context1).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset("assets/images/iconpending.png",width: 30,height: 30,color: Colors.red,),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      '$message',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                  ),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  child: Text("OK",style: TextStyle(color: CustomColors().backgroundColorAll),),
                ),
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: const Text('Information:'),
            content: IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                // height: 200,
                color: Colors.transparent,
                width: MediaQuery.of(context1).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset("assets/images/iconpending.png",width: 30,height: 30,color: Colors.red,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$message',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                   const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK",style: TextStyle(color: CustomColors().backgroundColorAll),),
                ),
              ),
            ],
          );
        }
      },
    );

  }

  dialogWindow({type,message,context}) {
    showDialog(
      context: context,
      builder: (context1) {
        if(Platform.isAndroid) {
          return AlertDialog(
            title: const Center(child: Text('Information:'),),
            backgroundColor: Colors.white,
            content: IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                // height: MediaQuery.of(context1).size.height/2,
                color: Colors.transparent,
                width: MediaQuery.of(context).copyWith().size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    (type=='success')?SvgPicture.asset("assets/images/success.svg",height: 30,width: 30,color: Colors.green,):
                    Image.asset("assets/images/iconpending.png",width: 30,height: 30,color: Colors.red,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$message',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding:const  EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                  ),
                  onPressed: () => {
                    Navigator.pop(context1),
                  },
                  child: Text("OK",style: TextStyle(color: CustomColors().backgroundColorAll),),
                ),
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: const Text('Information:'),
            content: IntrinsicHeight(
              child: Container(
                margin:const EdgeInsets.only(top: 10, bottom: 10),
                // height: MediaQuery.of(context1).size.height/2,
                color: Colors.transparent,
                width: MediaQuery.of(context).copyWith().size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    (type=='success')?SvgPicture.asset("assets/images/success.svg",height: 30,width: 30,color: Colors.green,):
                    Image.asset("assets/images/iconpending.png",width: 30,height: 30,color: Colors.red,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$message',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK",style: TextStyle(color: CustomColors().backgroundColorAll),),
                ),
              ),
            ],
          );
        }
      },
    );

  }

  dialogWindowBack({type,message,context}) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white
        ),
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      elevation: 30,
      backgroundColor: (type=='success')?Colors.green:Colors.red,
    ));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String phoneFormat({required String number}){
    try{
      String phone = number.replaceAll(" ", "");
      if(phone.toString().length==9){
        phone = '${phone.substring(0,3)} ${phone.substring(3,5)} ${phone.substring(5,7)} ${phone.substring(7,9)}';
        // String code = phone.toString().substring(0,5);
        // code = code.substring(0,2)+' '+code.substring(3,5);
        print('number: $phone');

      }
      return phone;
    }on Exception catch(_){
      return '';
    }
  }

  String ALPHABET_STRING = "abcdefghijklmnopqrstuvwxyz";
  String? decryptoSms(String sms){

    if (sms.isNotEmpty) {
      try {
        //les caracteres speciaux json

        String text = "";
        for (int i=0; i<sms.length;i++){
          switch (sms.substring(i, i + 1)) {
            case "\\":
              text = "$text{";
              break;
            case "<":
              text = "$text\"";
              break;
            case "\"":
              text = "$text}";
              break;
            default:
              text = '$text${sms.substring(i, i + 1)}';
              break;
          }

        }

        //3 derniere lettre de chaque mot inversion

        String number = "";

        int lastSpace = 0;
        String lastThree;

        for (int i=0; i<text.length;i++){
          if(text.substring(i,i+1)==" "){

            if (text.substring(lastSpace,i).length>3){
              number = '$number${text.substring(lastSpace,i-3)}';
              lastThree = text.substring(i-3,i);
              lastSpace = i;
              for (int j=lastThree.length;j>0;j--){
                number = '$number${lastThree.substring(j-1,j)}';
              }
            }else {
              number = '$number${text.substring(lastSpace,i)}';
              lastSpace = i;
            }


          }

          if(i==text.length-1){
            if (text.substring(lastSpace,i).length>3){
              number = '$number${text.substring(lastSpace,i-2)}';

              lastThree = text.substring(i-2,i+1);

              for (int j=lastThree.length;j>0;j--){
                number = '$number${lastThree.substring(j-1,j)}';
              }
            }else {
              number = '$number${text.substring(lastSpace,i+1)}';
            }


          }


        }

        //inversion
        String number1 = "";

        for (int i=number.length; i>0;i--){

          number1 = '$number1${number.substring(i-1, i)}';

        }

        number1 = decryptoNoInversion(number1);
        //2em passe substitution x=x+7
        String number2 = "";
        int i = 0;
        int l = 0;

        while (i<number1.length){
          if ((i+2)<number1.length){
            if(i==0){
              number2 = '$number2${number1.substring(i,i+1)}';
              i=i+1;
            }else {
              number2 = '$number2${number1.substring(i+1,i+2)}';
              i = i + 2;
            }

            for (int k=0;k<ALPHABET_STRING.length;k++){
              if (number1.toLowerCase().substring(i,i+1)==ALPHABET_STRING.substring(k,k+1)){
//                             System.out.println("avant "+ALPHABET_STRING.substring(k,k+1));
                if ((k+7)<ALPHABET_STRING.length){
                  number2 = '$number2${ALPHABET_STRING.substring(k+7,k+8)}';
//                                 System.out.println("apres "+ALPHABET_STRING.substring(k+7,k+8));
                }else {
                  String substring = ALPHABET_STRING.substring((k + 7) - ALPHABET_STRING.length, (k + 8) - ALPHABET_STRING.length);
//                                 System.out.println("apres "+ substring);
                  number2 = '$number2$substring';
                }

                l=1;
              }
            }
            if (l==0){
              number2 = '$number2${number1.substring(i,i+1)}';
            }else {
              l = 0;
            }
          }else {
            if ((i+1)<number1.length){
              number2 = '$number2${number1.substring(i+1,i+2)}';
            }
            break;
          }

        }
        //3em passe substitution x=x-2
        String number3 = "";
        i = 0;
        l = 0;

        while (i<number2.length){
          if ((i+3)<number2.length){
            if(i==0){
              number3 = '$number3${number2.substring(i,i+2)}';
              i=i+2;
            }else {
              number3 = '$number3${number2.substring(i+1,i+3)}';
              i = i + 3;
            }

            for (int k=0;k<ALPHABET_STRING.length;k++){
              if (number2.toLowerCase().substring(i,i+1)==ALPHABET_STRING.substring(k,k+1)){
//                                System.out.println("avant "+ALPHABET_STRING.substring(k,k+1));
                if ((k-2)>=0){
                  number3 = '$number3${ALPHABET_STRING.substring(k-2,k-1)}';
//                                    System.out.println("apres "+ALPHABET_STRING.substring(k-2,k-1));
                }else {
                  String substring = ALPHABET_STRING.substring((k - 2) + ALPHABET_STRING.length, (k - 1) + ALPHABET_STRING.length);
//                                    System.out.println("apres "+ substring);
                  number3 = '$number3$substring';
                }

                l=1;
              }
            }
            if (l==0){
              number3 = '$number3${number2.substring(i,i+1)}';
            }else {
              l = 0;
            }
          }else {
            if ((i+2)<number1.length){
              number3 = '$number3${number2.substring(i+1,i+3)}';
            }else if ((i+1)<number1.length){
              number3 = '$number3${number2.substring(i+1,i+2)}';
            }

            break;
          }

        }

        return number3;

      } on Exception catch (_){
        return null;
      }
    } else {
      return null;
    }
  }

  String decryptoNoInversion(String text){

    if (text.isNotEmpty) {
      try {

        String number = "";

        for (int i=0; i<text.length;i++){

          String substring = text.substring(i, i+1);

          switch (substring) {
            case "0":
              number = "${number}9";
              break;
            case "1":
              number = "${number}0";
              break;
            case "2":
              number = "${number}1";
              break;
            case "3":
              number = "${number}2";
              break;
            case "4":
              number = "${number}3";
              break;
            case "5":
              number = "${number}4";
              break;
            case "6":
              number = "${number}5";
              break;
            case "7":
              number = "${number}6";
              break;
            case "8":
              number = "${number}7";
              break;
            case "9":
              number = "${number}8";
              break;
            default:
              number = '$number${text.substring(i, i + 1)}';
              break;
          }
        }

        String number1 = "";


        for (int i=0; i<number.length;i++){

          String substring = number.substring(i, i+1);

          switch (substring) {
            case "0":
              number1 = "${number1}9";
              break;
            case "1":
              number1 = "${number1}8";
              break;
            case "2":
              number1 = "${number1}7";
              break;
            case "3":
              number1 = "${number1}6";
              break;
            case "4":
              number1 = "${number1}5";
              break;
            case "5":
              number1 = "${number1}4";
              break;
            case "6":
              number1 = "${number1}3";
              break;
            case "7":
              number1 = "${number1}2";
              break;
            case "8":
              number1 = "${number1}1";
              break;
            case "9":
              number1 = "${number1}0";
              break;
            default:
              number1 = '$number1${number.substring(i, i + 1)}';
              break;
          }
        }

        return number1;

      } on Exception catch (_){
        return "";
      }
    } else return "";

  }

  String crypto(String text){

    if (text.isNotEmpty) {
      try {
        String number = "";

        for (int i=0; i<text.length;i++){

          String substring = text.substring(i, i+1);

          switch (substring) {
            case "0":
              number = "${number}9";
              break;
            case "1":
              number = "${number}8";
              break;
            case "2":
              number = "${number}7";
              break;
            case "3":
              number = "${number}6";
              break;
            case "4":
              number = "${number}5";
              break;
            case "5":
              number = "${number}4";
              break;
            case "6":
              number = "${number}3";
              break;
            case "7":
              number = "${number}2";
              break;
            case "8":
              number = "${number}1";
              break;
            case "9":
              number = "${number}0";
              break;
          }
        }

        String number1 = "";

        for (int i=0; i<number.length;i++){

          String substring = number.substring(i, i+1);

          switch (substring) {
            case "0":
              number1 = "${number1}1";
              break;
            case "1":
              number1 = "${number1}2";
              break;
            case "2":
              number1 = "${number1}3";
              break;
            case "3":
              number1 = "${number1}4";
              break;
            case "4":
              number1 = "${number1}5";
              break;
            case "5":
              number1 = "${number1}6";
              break;
            case "6":
              number1 = "${number1}7";
              break;
            case "7":
              number1 = "${number1}8";
              break;
            case "8":
              number1 = "${number1}9";
              break;
            case "9":
              number1 = "${number1}0";
              break;
          }
        }

        String number2 = "";

        for (int i=number1.length; i>0;i--){

          number2 = "$number2${number1.substring(i-1, i)}";

        }
        return number2;

      } on Exception catch (_){
        return "";
      }
    } else return "";
  }

  String cryptoSms(String sms){

    if (sms.isNotEmpty) {
      try {

        //3em passe substitution x=x+2
        String number3 = "";
        int i = 0;
        int l = 0;

        while (i<sms.length){
          if ((i+3)<sms.length){
            if(i==0){
              number3 = '$number3${sms.substring(i,i+2)}';
              i=i+2;
            }else {
              number3 = '$number3${sms.substring(i+1,i+3)}';
              i = i + 3;
            }
//                        System.out.println("position "+i);

            for (int k=0;k<ALPHABET_STRING.length;k++){
              if (sms.toLowerCase().substring(i,i+1)==(ALPHABET_STRING.substring(k,k+1))){
//                                System.out.println("avant "+ALPHABET_STRING.substring(k,k+1));
                if ((k+2)<ALPHABET_STRING.length){
                  number3 = '$number3${ALPHABET_STRING.substring(k+2,k+3)}';
//                                    System.out.println("apres "+ALPHABET_STRING.substring(k+2,k+3));
                }else {
                  String substring = ALPHABET_STRING.substring((k + 2) - ALPHABET_STRING.length, (k + 3) - ALPHABET_STRING.length);
//                                    System.out.println("apres "+ substring);
                  number3 = '$number3$substring';
                }

                l=1;
              }
            }

            if (l==0){
              number3 = '$number3${sms.substring(i,i+1)}';
            }else {
              l = 0;
            }
          }else {
            if ((i+2)<sms.length){
              number3 = '$number3${sms.substring(i+1,i+3)}';
            }else if ((i+1)<sms.length){
              number3 = '$number3${sms.substring(i+1,i+2)}';
            }

            break;
          }

        }

        //2em passe substitution x=x-7
        String number2 = "";
        i = 0;
        l = 0;

        while (i<number3.length){
          if ((i+2)<number3.length){
            if(i==0){
              number2 = '$number2${number3.substring(i,i+1)}';
              i=i+1;
            }else {
              number2 = '$number2${number3.substring(i+1,i+2)}';
              i = i + 2;
            }

            for (int k=0;k<ALPHABET_STRING.length;k++){
              if (number3.toLowerCase().substring(i,i+1)==(ALPHABET_STRING.substring(k,k+1))){
//                                System.out.println("avant "+ALPHABET_STRING.substring(k,k+1));
                if ((k-7)>=0){
                  number2 = '$number2${ALPHABET_STRING.substring(k-7,k-6)}';
//                                    System.out.println("apres "+ALPHABET_STRING.substring(k-7,k-6));
                }else {
                  String substring = ALPHABET_STRING.substring((k - 7) + ALPHABET_STRING.length, (k - 6) + ALPHABET_STRING.length);
//                                    System.out.println("apres "+ substring);
                  number2 = '$number2$substring';
                }

                l=1;
              }
            }


            if (l==0){
              number2 = '$number2${number3.substring(i,i+1)}';
            }else {
              l = 0;
            }
          }else {
            if ((i+1)<number3.length){
              number2 = '$number2${number3.substring(i+1,i+2)}';
            }
            break;
          }

        }

        number2 = cryptoNoInversion(number2);
        String number1 = "";
        //inversion
        for (i=number2.length; i>0;i--){
          number1 = '$number1${number2.substring(i-1, i)}';
        }
        //3 derniere lettre de chaque mot inversion
        String number = "";

        int lastSpace = 0;
        String lastThree;

        for (i=0; i<number1.length;i++){
          if(number1.substring(i,i+1)==(" ")){

            if (number1.substring(lastSpace,i).length>3){
              number = '$number${number1.substring(lastSpace,i-3)}';
              lastThree = number1.substring(i-3,i);
              lastSpace = i;
              for (int j=lastThree.length;j>0;j--){
                number = '$number${lastThree.substring(j-1,j)}';
              }
            }else {
              number = '$number${number1.substring(lastSpace,i)}';
              lastSpace = i;
            }

          }

          if(i==number1.length-1){
            if (number1.substring(lastSpace,i).length>3){
              number = '$number${number1.substring(lastSpace,i-2)}';

              lastThree = number1.substring(i-2,i+1);

              for (int j=lastThree.length;j>0;j--){
                number = '$number${lastThree.substring(j-1,j)}';
              }
            }else {
              number = '$number${number1.substring(lastSpace,i+1)}';
            }
          }
        }
        //les caracteres speciaux json

        String text = "";
        for (i=0; i<number.length;i++){
          switch (number.substring(i, i + 1)) {
            case "{":
              text = text+''+("\\");
              break;
            case "\"":
              text = text+''+("<");
              break;
            case "}":
              text = text+''+("\"");
              break;
            default:
              text = '$text${number.substring(i, i + 1)}';
              break;
          }

        }

        return text;

      } on Exception catch (_){
        return "";
      }
    } else {
      return "";
    }
  }

  String cryptoNoInversion(String text){

    if (text.isNotEmpty) {
      try {
        String number = "";

        for (int i=0; i<text.length;i++){

          String substring = text.substring(i, i+1);

          switch (substring) {
            case "0":
              number = "{$number}9";
              break;
            case "1":
              number = "{$number}8";
              break;
            case "2":
              number = "{$number}7";
              break;
            case "3":
              number = "{$number}6";
              break;
            case "4":
              number = "{$number}5";
              break;
            case "5":
              number = "{$number}4";
              break;
            case "6":
              number = "{$number}3";
              break;
            case "7":
              number = "{$number}2";
              break;
            case "8":
              number = "{$number}1";
              break;
            case "9":
              number = "{$number}0";
              break;
            default:
              number = '$number${text.substring(i, i + 1)}';
              break;
          }
        }

        String number1 = "";

        for (int i=0; i<number.length;i++){

          String substring = number.substring(i, i+1);

          switch (substring) {
            case "0":
              number1 = "{$number1}1";
              break;
            case "1":
              number1 = "{$number1}2";
              break;
            case "2":
              number1 = "{$number1}3";
              break;
            case "3":
              number1 = "{$number1}4";
              break;
            case "4":
              number1 = "{$number1}5";
              break;
            case "5":
              number1 = "{$number1}6";
              break;
            case "6":
              number1 = "{$number1}7";
              break;
            case "7":
              number1 = "{$number1}8";
              break;
            case "8":
              number1 = "{$number1}9";
              break;
            case "9":
              number1 = "{$number1}0";
              break;
            default:
              number1 = '$number1${number.substring(i, i + 1)}';
              break;
          }
        }

        return number1;

      } on Exception catch (_){
        return "";
      }
    } else {
      return "";
    }
  }

  // multi platform function

  TextFormField textFieldIosAndroid({
    required controller,
    required style,
    required keyboardType,
    required textInputAction,
    required decoration,
    required validator,
    required maxlength
  }){
    return
      //Platform.isAndroid ?
      TextFormField(
        controller: controller,
        style: style,
        // textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: decoration,
        validator: validator,
        maxLength: maxlength,
      );
  }

  Widget textPasswordFieldIosAndroid(
      {required controller,
        required style,
        required keyboardType,
        required textInputAction,
        required decoration,
        required validator,
        required obscureText,
        required onFieldSubmitted})
  {
    return
      //Platform.isAndroid ?
      TextFormField(
          controller: controller,
          style: style,
          // textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: decoration,
          validator: validator,
          obscureText: obscureText,
          onFieldSubmitted:onFieldSubmitted
      );
  }

  Widget elevatedButtonIosAndroid({required onPressed,required style,child,required colorIOS,required borderRadiusIOS}){
    return
      //Platform.isAndroid ?
      ElevatedButton(
          onPressed: onPressed,
          style: style,
          child:child
      );

  }
  Widget scaffoldIosAndroid({body,backgroundColor,bottomNavigationBar}){
    return Platform.isAndroid ? Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    ): CupertinoScaffold(
      transitionBackgroundColor: backgroundColor,
      body: body,
    );
  }
  Widget animationContent({
    required context,
    required double verticalOffset,
    required double horizontalOffset,
    required duration,
    required Widget child
  }){
    return SlideAnimation(
      verticalOffset: verticalOffset,
      horizontalOffset: horizontalOffset,
      duration: duration,
      child: FadeInAnimation(
        child: child,
      ),
    );
  }

  Widget animationColumn({
    required context,
    required MainAxisAlignment mainAxisAlignment,
    required CrossAxisAlignment crossAxisAlignment,
    required List<Widget> children}){
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 1000),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 0.0,
            verticalOffset: 0.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget animationSynchronized({required child}){
    return AnimationConfiguration.synchronized(
      // Configure your animation settings here
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }

  Widget animationContentTop({
    required context,
    required Widget child
  }){
    return SlideAnimation(
      verticalOffset: -MediaQuery.of(context).size.height,
      horizontalOffset: 0.0,
      duration: const Duration(milliseconds: 1500),
      child: FadeInAnimation(
        child: child,
      ),
    );
  }

  Widget animationContentBottom({
    required context,
    required Widget child
  }){
    return SlideAnimation(
      verticalOffset: MediaQuery.of(context).size.height,
      horizontalOffset: 0.0,
      duration: const Duration(milliseconds: 1500),
      child: FadeInAnimation(
        child: child,
      ),
    );
  }

  Widget animationContentLeft({
    required context,
    required Widget child
  }){
    return SlideAnimation(
      verticalOffset: 0.0,
      horizontalOffset: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 1500),
      child: FadeInAnimation(
        child: child,
      ),
    );
  }
  Widget animationContentRight({
    required context,
    required Widget child
  }){
    return SlideAnimation(
      verticalOffset: 0.0,
      horizontalOffset: -MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 1500),
      child: FadeInAnimation(
        child: child,
      ),
    );
  }



  bool isDate(String str) {
    try {
      if(str.length==10){
        print(str.substring(6));
        print(str.substring(3,5));
        print(str.substring(0,2));
        if(str.substring(6).isNumericOnly&&str.substring(3,5).isNumericOnly&&str.substring(0,2).isNumericOnly){
          if(int.parse(str.substring(6))>=1900&&int.parse(str.substring(3,5))<=12&&int.parse(str.substring(0,2))<=31){
            String date = "${str.substring(6)}-${str.substring(3,5)}-${str.substring(0,2)}";
            DateTime.parse(date);
          }else {
            return false;
          }
        }else{
          DateTime.parse(str);
        }
      }else{
        DateFormat.yMd().parse(str);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  String generateRandomString(int length) {
    final random = Random.secure();
    const values = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    const int valuesLength = values.length;
    final List<int> randomIndices = List<int>.generate(length, (_) => random.nextInt(valuesLength));

    final bytes = Uint8List.fromList(randomIndices.map((index) => values.codeUnitAt(index)).toList());
    final randomString = base64Url.encode(bytes);

    return randomString.substring(0, length);
  }
}
class ZoomDialog extends StatefulWidget {
  final String description;
  final String imageArticle;
  final String prix;
  final String viewNombre;
  final String categorie;
  var couleur;
  var taille;

  final int idProduit;


  ZoomDialog({
    required this.description,
    required this.imageArticle,
    required this.prix,
    required this.viewNombre,
    required this.categorie,
    required this.couleur,
    required this.taille,
    required this.idProduit,



  });

  @override
  _ZoomDialogState createState() => _ZoomDialogState();
}

class _ZoomDialogState extends State<ZoomDialog> {

  // Variable pour suivre quel bouton est sélectionné
  String selectedButton = '';


  var valeurIdtaille=0;

  // Méthode pour gérer la sélection d'un bouton
  void selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName; // Mise à jour de l'état avec le bouton sélectionné
    });
  }




  String selectedColor = ''; // Couleur sélectionnée, vide par défaut.
  var valeurIdCouleur=0;
  // Méthode pour mettre à jour la couleur sélectionnée
  void selectColor(String color) {
    setState(() {
      selectedColor = color; // Mettez à jour l'état de la couleur sélectionnée
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildHeader(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImageZoom(context),
          _buildProductDetails(),
          _buildColorOptions(),
          _buildSizePoinureOrTaille(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.asset(
          "assets/images/logo.jpeg",
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  Widget _buildImageZoom(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Zoom(
        initTotalZoomOut: true,
        maxZoomHeight: MediaQuery.of(context).size.height * 0.35,
        maxZoomWidth: MediaQuery.of(context).size.width * 0.6,
        doubleTapZoom: true,
        child: Center(child:CachedNetworkImage(
          imageUrl: widget.imageArticle,

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
        ),),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "✰✰✰✰✰",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text("${widget.viewNombre} artiches"),
            SizedBox(width: 10),
            Text(
              "disponible",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width:280 ,
              child: Text(widget.description,
              overflow: TextOverflow.ellipsis,),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              NumberFormat.currency(locale: 'eu',decimalDigits: 0,
                  symbol: devise).format(double.tryParse(widget.prix)!.toInt()),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Couleurs"),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.couleur.map<Widget>((item) {
            String colorName = item['vcCouleur'].toString();
            int idCouleur = item['id'];

            bool isSelected = valeurIdCouleur == idCouleur;

            return GestureDetector(
              onTap: () {
                setState(() {
                  valeurIdCouleur = idCouleur;
                  selectedColor = colorName;
                });
              },
              child: _colorOption(
                colorName,
                getColorFromName(colorName),
                isSelected,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }



  Color getColorFromName(String name) {
    switch (name.toUpperCase()) {
      case 'ROUGE':
        return Colors.red;
      case 'BLUE':
        return Colors.blue.shade600;
      case 'VERT':
        return Colors.green.shade600;
      case 'KAKI':
        return Colors.brown;
      case 'NOIR':
        return Colors.black;
      case 'BLANCHE':
        return Colors.white;
      default:
        return Colors.grey; // couleur par défaut
    }
  }

  Widget _colorOption(String colorName, Color color, bool isSelected) {
    bool isSelected = selectedColor == colorName; // Vérifie si cette couleur est sélectionnée

    return InkWell(
      onTap: () {
        selectColor(colorName); // Met à jour la couleur sélectionnée
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            colorName,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.black, // Changer la couleur du texte si sélectionnée
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSizePoinureOrTaille() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pointure"),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.taille.map<Widget>((item) {
            String taille = item['vcTaille'].toString();
            int idTaille = item['id'];

            bool isSelected = selectedButton == taille;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedButton = taille;
                  valeurIdtaille = idTaille;
                });
              },
              child: _sizeOption(
                taille,
                isSelected,
                isSelected ? Colors.green : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }



  Widget _sizeOption(String size, bool isSelected,Color defaultColor,) {
    return InkWell(
      onTap: () {
        selectButton(size);

      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : defaultColor, // Si sélectionné, couleur rouge
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) => Vetement()));
              },
              icon: Icon(Icons.arrow_back),
            ),
            _actionButton("Ajouter au panier", Colors.orange.shade600),
            _actionButton("❤️", Colors.white, textColor: Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(String label, Color backgroundColor, {Color textColor = Colors.black}) {
    return InkWell(
      onTap: () {
        print("Taille sélectionnée : $selectedButton");
        print("Couleur sélectionnée : $selectedColor");

        if (label == "Ajouter au panier") {
          // 🔒 Vérification
          if (selectedButton == null || selectedColor == null) {
            Flushbar(
              message: " Veuillez sélectionner une taille et une couleur",
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.red,
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
            return;
          }
          // 🎯 Récupère l'idTaille
          final tailleMatch = dataidTailleAndTaille.firstWhere(
                (item) => item['vcTaille'].toString().toUpperCase() == selectedButton!.toUpperCase(),
            orElse: () => null,
          );

          // 🎯 Récupère l'idCouleur
          final couleurMatch = dataIdCouleurAndCouleur.firstWhere(
                (item) => item['vcCouleur'].toString().toUpperCase() == selectedColor!.toUpperCase(),
            orElse: () => null,
          );

          if (tailleMatch == null || couleurMatch == null) {
            Flushbar(
              message: " Veuillez sélectionner une taille et une couleur",
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.red,
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
            return;
          }

          final int idTaille = tailleMatch['id'];
          final int idCouleur = couleurMatch['id'];



          final int idProduitPanierAjoute = int.parse(idProduitPanier.toString());

          Map<String, dynamic> nouvelleCombinaison = {
            "idCouleur": idCouleur,
            "idTaille": idTaille,
            "idProduit": idProduitPanierAjoute,
            "quantite": 1
          };

          // ✅ Vérifie les doublons
          if (!resultatFinalId.any((e) =>
          e['idCouleur'] == nouvelleCombinaison['idCouleur'] &&
              e['idTaille'] == nouvelleCombinaison['idTaille'] &&
              e['idProduit'] == nouvelleCombinaison['idProduit'])) {
            resultatFinalId.add(nouvelleCombinaison);
          }

          print("Liste finale id taille et id couleur : $resultatFinalId");
          ajouterAuPanier(context);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ),
    );
  }

  void ajouterAuPanier(BuildContext context) {
    final indexExistant = monPanier.indexWhere((produit) =>
    produit.nom == widget.description &&
        produit.prix == widget.prix &&
        produit.couleur == selectedColor &&
        produit.taille == selectedButton &&
        produit.categorie == widget.categorie &&
        produit.imageArticle == widget.imageArticle &&
        produit.idProduit == widget.idProduit && // Ajoute ce check si nécessaire
        produit.idCouleur == valeurIdCouleur &&
        produit.idTaille == valeurIdCouleur
    );

    if (indexExistant != -1) {
      setState(() {
        monPanier[indexExistant].quantite += 1;
        for (var item in resultatFinalId) {
          if (item['idProduit'] == monPanier[indexExistant].idProduit) {
            item['quantite'] = monPanier[indexExistant].quantite;
            break; // Stop après la modification (si idProduit est unique)
          }
        }
        print(resultatFinalId);
      });
      logn(context);
      Flushbar(
        message: " Quantité augmentée avec succès!",
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Quantité augmentée !"),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    } else {
      monPanier.add(
        Produit(
          nom: widget.description,
          prix: widget.prix,
          couleur: selectedColor,
          taille: selectedButton,
          quantite: 1,
          categorie: widget.categorie,
          imageArticle: widget.imageArticle,

          idProduit: widget.idProduit,
          idCouleur: valeurIdCouleur,
          idTaille: valeurIdtaille,
        ),
      );
      print("***************je rentre bien ici******");
      for (var produit in monPanier) {
        print("Produit : ${produit.nom}, ID: ${produit.idProduit}, Quantité: ${produit.quantite},");
      }
      Flushbar(
        message: " Produit ajouté au panier! ",
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);

    }

    setState(() {
      nombreArticlePanier = monPanier.length;
      print("*********le nombre d'article dans le panier***");
      print(nombreArticlePanier);
    });
    logn(context);
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
      //Page de vetement
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => Vetement()),
        // );
      });
    });
  }
}
//*******la liste des produits de mon panier
class Produit {
  String nom;
  String prix;
  String couleur;
  String taille;
  int quantite;
  String  categorie;
  String imageArticle;


  final int idProduit;
  final int idCouleur;
  final int idTaille;

  Produit({

    required this.nom,
    required this.prix,
    required this.couleur,
    required this.taille,
    required this.quantite,
    required this.imageArticle,
    required this.categorie,

    required this.idProduit,
    required this.idCouleur,
    required this.idTaille,
  });

  double get prixTotal => double.tryParse(prix)! * quantite;
  // ✅ Cette méthode permet d'encoder le produit pour l'API

}

//************decor
class DecorJohn {

  String descriptionDescor;
  String imageDecor;
  int idDecor;
  DecorJohn({
    required this.imageDecor,
    required this.descriptionDescor,
    required this.idDecor

  });
}

