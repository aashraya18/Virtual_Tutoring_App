import '../google_sheet/call_log.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class LogController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;

  // Google App Script Web URL
  static const String URL = "https://script.google.com/macros/s/AKfycbw0Tpk3DKBst_YE-LPRNF_SGBHAgenK8CN037gORJI1m2HOi0NY/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  LogController(this.callback);

  void submitForm(VideoCallLog logForm) async{
    try{
      await http.get(URL + logForm.toParams()).then(
              (response){
            callback(convert.jsonDecode(response.body)['status']);
          });
    } catch(e){
      print(e);
    }
  }
}