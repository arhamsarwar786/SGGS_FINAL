// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sggs/components/widgets.dart';
import 'package:sggs/model/language_model.dart';
import 'package:sggs/model/model.dart';
import 'package:sggs/utils/http_services.dart';
import 'package:sizer/sizer.dart';

import 'Mainpage.dart';
import 'components/widgets.dart';
import 'model/global_state.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Timer(Duration(seconds: 5), () {
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
  //   });
  // }
  List<Language>? languagesList;

  @override
  void initState() {
    fetchListLanguages();
    super.initState();
  }
  fetchListLanguages() async {
    languagesList = await APIManager().getLanguages(context);

    setState(() {
    // for (var item in languagesList) {
    //   if(item.name == "Gurmukhi" && item.id == '1'){
    //     languagesList!.remove(item);
    //   }
    // }
    
      
    });
  }


  String _chosenValue = 'Please choose a langauage';

  // List of items in our dropdown menu




  Future<bool> onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: ()async{
          //       print(languagesList);

          //       languagesList!.forEach(( language) {
          //         print(language.id.runtimeType);
          //        });          
          // }),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 30.h,
                    width: 65.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'Assets/Splash.png',
                            ),
                            fit: BoxFit.fill)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "A  JOURNEY TOWARDS SPIRITUALITY",
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'CinzelDecorative',
                        fontSize: 3.w,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // DropDwon..............................
                  (languagesList == null || languagesList!.isEmpty)
                      ? Container(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(0.0),
                          child: DropdownButton(
                            // value: _chosenValue,
                            elevation: 5,
                            style: TextStyle(color: Colors.black),
                            items: languagesList!.map((value) {
                              return DropdownMenuItem<String?>(
                                value: value.name,
                                child: Text(value.name!),
                              );
                            }).toList(),
                            hint: Text(
                              _chosenValue,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onChanged: (dynamic value) {
                              setState(() {
                                _chosenValue = value;
                              });
                            },
                          ),
                        ),

                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      if (_chosenValue == "Please choose a langauage") {
                        snackBar(context, _chosenValue);
                      } else {
                        print(_chosenValue);
                        for (var item in languagesList!) {
                          if (item.name == _chosenValue) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(item.id!)));
                                    break;
                          }
                        }
                      }
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        child: Image.asset("Assets/arrow.png")),
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "By SGGSonline.com",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 4.w),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
