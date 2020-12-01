
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/Models/address.dart';
import 'package:udi_rider/mapConfig.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
      String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
      String placeAddress = "";

      var response = await RequestAssistant.getRequest(url);

      if (response != "Failed")
        {
          placeAddress = response["results"][0]["formatted_address"];

          Address userPickUpAddress = new Address();
          userPickUpAddress.longitude = position.longitude;
          userPickUpAddress.latitude = position.latitude;
          userPickUpAddress.placeName = placeAddress;

          Provider.of<AppData>(context, listen: false).updatePickupLocationAddress(userPickUpAddress);
        }

      return placeAddress;
  }
}