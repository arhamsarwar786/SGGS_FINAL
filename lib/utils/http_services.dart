import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sggs/model/global_state.dart';
import 'package:sggs/model/language_model.dart';
import 'package:sggs/model/model.dart';
import 'api_services.dart';


class APIManager{
  http.Client client = http.Client();

  Future<List<Language>?> getLanguages(BuildContext context) async {
      try{
      return await client
        .get(Uri.parse(ApiServices.getLanguages)).then((value){
          var data =   GetLanguageModel.fromJson(jsonDecode(value.body));
          GlobalState.getLanguagesSaved = data;
          return data.languages;
        });
      }catch(e){
        // ignore: avoid_print
        print(e);
      }
  }




  Future getContent(BuildContext context,langId) async {
      try{
      return await client
        .get(Uri.parse(ApiServices.getContent+"?lang_id=$langId"))
        .then((value){
          
          // GlobalState.getLanguagesSaved = data;
          return value.body;
        });
      }catch(e){
        // ignore: avoid_print
        print(e);
      }
  }




Future getPageContent(BuildContext context,langId,pageNo) async {
      try{
      return await client
        .get(Uri.parse(ApiServices.getContent+"?lang_id=$langId&page_no=$pageNo"))
        .then((value){          
          // GlobalState.getLanguagesSaved = data;
          return value.body;
        });
      }catch(e){
        // ignore: avoid_print
        print(e);
      }
  }



    Future getListContent(BuildContext context) async {
      try{
      return await client
        .get(Uri.parse(ApiServices.getContent))
        .then((value){                    
          print("This Is The Complete List : ${value.body}");
          // GlobalState.getLanguagesSaved = data;
          return value.body;
        });
      }catch(e){
        // ignore: avoid_print
        print(e);
      }
  }
}