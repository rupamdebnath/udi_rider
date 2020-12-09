import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/AllWidgets/Divider.dart';
import 'package:udi_rider/AllWidgets/progressDialog.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/Models/address.dart';
import 'package:udi_rider/Models/placePredictions.dart';
import 'package:udi_rider/mapConfig.dart';



class  SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickUpController.text = placeAddress;
    return Scaffold(
      resizeToAvoidBottomPadding: false,    //otherwise was getting error "Bottom overflowed by 99 pixels"
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                            Icons.arrow_back),
                      )
                      ,
                      Center(
                        child: Text("Enter the Drop off location", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),
                      )
                    ],
                  ),

                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpController,
                                decoration: InputDecoration(
                                  hintText: "Pickup location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                ),

                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (value)
                              {
                                findPlace(value);  //calling the function to predict place Name and show response in terminal
                              },
                              controller: dropOffController,
                              decoration: InputDecoration(
                                hintText: "DropOff location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ], //children
             ),
          ),
        ),

          //tile for predictions using Ternary operator to show the List if the length of the entered string id greater than 0 else show null container

          (placePredictionList.length > 0 )
              ? Padding
                (
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListView.separated
                      (
                        padding : EdgeInsets.all(0.0),
                        itemBuilder: (context, index)
                        {
                          return PredictionTile(placePredictions: placePredictionList[index],);
                        },
                        separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                        itemCount: placePredictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),

                )
              : Container(),

        ], //children
      ),

    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in"; //using google place api to fetch the place prediction name, and country code for India so that only country relevant places are shown

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed")
        {
          return;
        }

      if (res["status"] == "OK")
      {
        var predictions = res["predictions"]; //Json values being retrieved from AutoComplete Place
        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList(); //convert the Json values as a List using placePredictions.dart model class
        setState(() {
          placePredictionList = placeList;
        });
      }
      print("Places Prediction Responses using the google place api :::: ");  //Print statements that print the response in terminal, not required when List view is created for user to see
      print(res);
    } // function to predict the place name and show the response in terminal, need to show in a list view to user later on
  }
}

//Predictions Class here
class PredictionTile extends StatelessWidget
{
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);
    @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
          //making the predictions list clickable
      child: Container(
        child: Column(
          children:
          [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 20.0,),
                      Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                    ],
                  ),
                ),
              ], //children
            ),
            SizedBox(width: 10.0,),
          ],//children
        ),
      ),
    );
  }
  void getPlaceAddressDetails(String placeId,context) async
  {
    showDialog
      (
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Setting the drop off point, please wait...",)
      );
    //displaying pop up dialog to the user while the values are being updated

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context); //closing the popup dialog once the clicked location address is fetched


    if (res == "failed")
      {
        return;
      }
    if (res["status"] == "OK")
      {
        Address address = Address();
        address.placeName = res["result"]["name"];
        address.placeId = placeId;
        address.latitude = res["result"]["geometry"]["location"]["lat"];
        address.latitude = res["result"]["geometry"]["location"]["lng"];    //google places api fetching the names should be exactly what is mentioned in developers site
        
        Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
        print("Drop Location :::: ");
        print(address.placeName);   //just printing in terminal for testing
      }
  }
  //function to get the place details
}
