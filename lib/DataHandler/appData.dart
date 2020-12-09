import 'package:flutter/cupertino.dart';
import 'package:udi_rider/Models/address.dart';

class AppData extends ChangeNotifier
{
    Address pickupLocation, dropoffLocation;

    void updatePickupLocationAddress(Address pickupAddress)
    {
      pickupLocation = pickupAddress;
      notifyListeners();
    }

    void updateDropOffLocationAddress(Address dropOffAddress)
    {
      dropoffLocation = dropOffAddress;
      notifyListeners();
    }
}