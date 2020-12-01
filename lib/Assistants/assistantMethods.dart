
import 'package:geolocator/geolocator.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/mapConfig.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position) async
  {
      String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
      String placeAddress = "";

      var response = await RequestAssistant.getRequest(url);

      if (response != "Failed")
        {
          placeAddress = response["results"][0]["formatted_address"];
        }

      return placeAddress;
  }
}