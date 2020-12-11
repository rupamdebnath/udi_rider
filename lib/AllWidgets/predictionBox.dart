

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/AllWidgets/progressDialog.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/Models/placePredictions.dart';
import 'package:udi_rider/Models/address.dart';
import 'package:udi_rider/mapConfig.dart';
import 'package:udi_rider/DataHandler/appData.dart';

class PredictionBox extends StatelessWidget {

  final PlacePredictions predictions;

  PredictionBox(this.predictions);

  //function to fetch the place details clicked by user
  void fetchPlaceDetails(String placeId, context) async
  {
    //ProgressDialog(message: "Please wait...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...."),
    );

    String url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(url);
    Navigator.pop(context);           //close progressdialog box once response is fetched

    if (res == "failed")
      {
        return;
      }

    if (res["status"] == "OK")
    {
        Address placeDetails = Address();
        placeDetails.placeName = res["result"]["name"];
        placeDetails.placeId = placeId;
        placeDetails.latitude = res["result"]["geometry"]["location"]["lat"];
        placeDetails.longitude = res["result"]["geometry"]["location"]["lng"];

        Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(placeDetails);
        print(placeDetails.placeName);

        Navigator.pop(context, "directionFound");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        fetchPlaceDetails(predictions.place_id, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8.0,),
            Row
              (
              children: <Widget>[
                Icon(Icons.location_on, color: Colors.redAccent,),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(predictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),),
                      SizedBox(height: 2,),
                      Text(predictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black38, fontSize: 12),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0,)

          ],
        ),
      ),
    );
  }
}
