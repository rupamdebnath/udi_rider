import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/mapConfig.dart';



class  SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickUpController.text = placeAddress;
    return Scaffold(
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
                ],
            ),
            ),
          ),
        ],
      ),

    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in"; //using google place api to fetch the place prediction name, and country code for India so that only country relevant places are shown

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed")
        {
          return;
        }
      print("Places Prediction Responses using the google place api :::: ");
      print(res);
    } // function to predict the place name and show the response in terminal, need to show in a list view to user later on
  }
}

