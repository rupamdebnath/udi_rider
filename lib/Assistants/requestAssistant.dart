import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestAssistant
{
  static Future<dynamic> getRequest(String url) async
  {
    http.Response response = await  http.get(url); //http response

    try
    {
      if (response.statusCode == 200) {
        String json_Data = response.body;
        var decodeData = jsonDecode(json_Data);
        return decodeData;
      }
      else {
        return "Failed";  //exact spelling of Failing required as it is used in AssistantMethods
      }
    }
    catch (exp)
    {
      return "Failed"; //exact spelling of Failing required as it is used in AssistantMethods
    } //try catch exception for failing request
  }
}