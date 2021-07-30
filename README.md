# ParkingApp
### Table of contents
* [Project description](#project-description)
* [Used technologies](#used-technologies)
* [How to compile it?](#how-to-compile-it)
* [How to use it?](#how-to-use-it)
* [Project status](#project-status)
* [Credits](#credits)

### Project description
*In progress*

### Used technologies
*In progress*

### How to compile it?
ParkingApp uses Google Maps APIs: **Maps SDK for Android** and **Maps SDK for iOS**. 
It means that you'll have to generate your own API key as it is not contained in this repository. 
To do this, follow the steps from this [instruction](https://developers.google.com/maps/gmp-get-started). 
After you get the Key, place it in the **line 11 of ios/Runner/AppDelegate.swift file**:
```
GMSServices.provideAPIKey("YOUR_API_KEY")    // PLACE YOUR API KEY HERE
```

and in **line 9 of android/app/src/main/AndroidManifest.xml**:
```
android:value="YOUR_API_KEY"/>    <!-- PLACE YOUR API KEY HERE -->
```

### How to use it?
*In progress*

### Project status
The project is still **in progress**.

### Credits
Special thanks to:
* [The Net Ninja](https://www.youtube.com/watch?v=1ukSR1GRtMU&list=RDCMUCW5YeuERMmlnqo4oq8vwUpg) - for amazing tutorial with Flutter basics,
* [Anmol Gupta](https://medium.com/flutterdevs/moor-database-in-flutter-6a78d91b10e5) - for showing Moor basics,
* [Pavithran](https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6) - for showing how to use Google Maps API,
* [Pradip Debnath](https://www.youtube.com/watch?v=gTHKFRRSPss) - for showing how to add markers and custom marker,
* [MitchSRobinson](https://github.com/flutter/flutter/issues/39797) - for showing how to (temporarily) fix Google Maps black screen issue,
* [Vectors Market](https://www.flaticon.com/authors/vectors-market) - for parking pin icon.