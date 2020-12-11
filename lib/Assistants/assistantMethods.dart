
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/Models/address.dart';
import 'package:udi_rider/Models/directionDetails.dart';
import 'package:udi_rider/mapConfig.dart';

class AssistantMethods
{
  //Assistance Method one to fetch the address long name from the given coordinates
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
      String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
      String placeAddress = "";
      String st1, st2, st3, st4;

      var response = await RequestAssistant.getRequest(url);

      if (response != "Failed")
        {
          //placeAddress = response["results"][0]["formatted_address"];  //not required to display full address as privacy risk and unwanted data
          st1 = response["results"][0]["address_components"][3]["long_name"];  //developers.google.com/maps/documentation/geocoding
          st2 = response["results"][0]["address_components"][4]["long_name"];
          st3 = response["results"][0]["address_components"][5]["long_name"];
          st4 = response["results"][0]["address_components"][6]["long_name"];
          placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;      //the full address
          Address userPickUpAddress = new Address();
          userPickUpAddress.longitude = position.longitude;
          userPickUpAddress.latitude = position.latitude;
          userPickUpAddress.placeName = placeAddress;

          Provider.of<AppData>(context, listen: false).updatePickupLocationAddress(userPickUpAddress);
        }

      return placeAddress;
  }

  static Future<DirectionDetails>getDirectionDetails(LatLng startingPoint, LatLng endingPoint) async
  {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startingPoint.latitude},${startingPoint.longitude}&destination=${endingPoint.latitude},${endingPoint.longitude}&mode=driving&key=$mapKey";

    var res = await RequestAssistant.getRequest(url);

    if (res == 'failed')
      {
        return null;
      }

    DirectionDetails directionDetails = new DirectionDetails();
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    return directionDetails;
  }
}