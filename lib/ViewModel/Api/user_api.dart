import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../Helper/app_const.dart';

class UserApi {



  Future<http.Response> getUser() async{
    final response = await http.get(
      Uri.parse('${AppConst.endPoint}/user'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
      },
    ).timeout(const Duration(seconds: 8));
    return response;
  }





  Future<http.Response> updateUser({
    String? username,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? language,
    String? countryCode,
    String? phone,
    String? pushToken,
    File? photo,
  }) async {
    var uri = Uri.parse('${AppConst.endPoint}/user');

    var request = http.MultipartRequest('POST', uri); // use POST
    request.fields['_method'] = 'PUT'; // spoof PUT for Laravel

    // headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppConst.prefs.getString('token')}',
    });

    // fields
    if (username != null) request.fields['username'] = username;
    if (firstName != null) request.fields['first_name'] = firstName;
    if (lastName != null) request.fields['last_name'] = lastName;
    if (birthday != null) request.fields['birthday'] = birthday.toIso8601String();
    if (language != null) request.fields['language'] = language;
    if (countryCode != null) request.fields['country_code'] = countryCode;
    if (phone != null) request.fields['phone'] = phone;
    if (pushToken != null) request.fields['push_token'] = pushToken;

    // file
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }

    // send
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }


  Future<http.Response> uploadImage({required String image}) async {
    return await http.post(
        Uri.parse('${AppConst.endPoint}/upload-profile-pic'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
        },
        body: {
          'file' : image,
        }

    );
  }




  Future<void> signFirebaseInAnonymously() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user == null){
        user = (await FirebaseAuth.instance.signInAnonymously()).user;
      }



    } catch (e) {

    }
  }






}
