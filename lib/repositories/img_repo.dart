import 'dart:convert';

import 'package:cloudinary/cloudinary.dart';
import "package:chat_app/cloudinary_options.dart";
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgRepo {
  Future<String> uploadImg(String imgPath) async {
    try{
    CloudinaryOptions cld = CloudinaryOptions();
    //var cldConfig = Cloudinary.signedConfig(apiKey:  cld.api_key, apiSecret: cld.api_sec, cloudName: "dgnonfezw");
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dgnonfezw/upload');
    final request = http.MultipartRequest("POST", url)
    ..fields['upload_preset'] = "chatapp"
    ..files.add(await http.MultipartFile.fromPath('file', imgPath));
      final response = await request.send();
      if(response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        print(jsonMap['url']);
        return jsonMap['url'];
      }
    } catch(e){
        print("message $e");
        return e.toString();
    }
    throw Error();
  }
}