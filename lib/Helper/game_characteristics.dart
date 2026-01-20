import 'package:get/get.dart';

enum GameCharacteristic {
  cafeteria,
  shower,
  bathroom,
  restaurant,
  parking,
  openStadium,
  indoorStadium,
  wifiAccess;

  static GameCharacteristic fromString(String characteristic) {
    switch (characteristic.toLowerCase()) {
      case 'cafeteria':
      case 'cafeteria ☕️':
        return GameCharacteristic.cafeteria;
      case 'shower':
      case 'shower 🚿':
        return GameCharacteristic.shower;
      case 'bathroom':
      case 'bathroom 🚻':
        return GameCharacteristic.bathroom;
      case 'restaurant':
      case 'restaurant 🥪':
        return GameCharacteristic.restaurant;
      case 'parking':
      case 'parking 🅿️':
        return GameCharacteristic.parking;
      case 'open_stadium':
      case 'open stadium 🏟️☀️':
        return GameCharacteristic.openStadium;
      case 'indoor_stadium':
      case 'indoor stadium 🏟️🏠':
        return GameCharacteristic.indoorStadium;
      case 'wifi_access':
      case 'wi-fi access 📶':
        return GameCharacteristic.wifiAccess;
      default:
        return GameCharacteristic.cafeteria;
    }
  }

  String get value {
    switch (this) {
      case GameCharacteristic.cafeteria:
        return 'cafeteria';
      case GameCharacteristic.shower:
        return 'shower';
      case GameCharacteristic.bathroom:
        return 'bathroom';
      case GameCharacteristic.restaurant:
        return 'restaurant';
      case GameCharacteristic.parking:
        return 'parking';
      case GameCharacteristic.openStadium:
        return 'open_stadium';
      case GameCharacteristic.indoorStadium:
        return 'indoor_stadium';
      case GameCharacteristic.wifiAccess:
        return 'wifi_access';
    }
  }

  String get displayName {
    if(Get.locale?.languageCode != 'ar'){
      switch (this) {
        case GameCharacteristic.cafeteria:
          return 'Cafeteria ☕️';
        case GameCharacteristic.shower:
          return 'Shower 🚿';
        case GameCharacteristic.bathroom:
          return 'Bathroom 🚻';
        case GameCharacteristic.restaurant:
          return 'Restaurant 🥪';
        case GameCharacteristic.parking:
          return 'Parking 🅿️';
        case GameCharacteristic.openStadium:
          return 'Open Stadium 🏟️☀️';
        case GameCharacteristic.indoorStadium:
          return 'Indoor Stadium 🏟️🏠';
        case GameCharacteristic.wifiAccess:
          return 'Wi-Fi Access 📶';
      }
    }
    else{
      switch (this) {
        case GameCharacteristic.cafeteria:
          return 'كافيتيريا ☕️';
        case GameCharacteristic.shower:
          return 'دش 🚿';
        case GameCharacteristic.bathroom:
          return 'دورة مياه 🚻';
        case GameCharacteristic.restaurant:
          return 'مطعام 🥪';
        case GameCharacteristic.parking:
          return 'موقف سيارات 🅿️';
        case GameCharacteristic.openStadium:
          return 'ملعب مفتوح 🏟️☀️';
        case GameCharacteristic.indoorStadium:
          return 'ملعب مغطى 🏟️🏠';
        case GameCharacteristic.wifiAccess:
          return 'واي فاي 📶';
      }
    }

  }

  String get icon {
    switch (this) {
      case GameCharacteristic.cafeteria:
        return '☕️';
      case GameCharacteristic.shower:
        return '🚿';
      case GameCharacteristic.bathroom:
        return '🚻';
      case GameCharacteristic.restaurant:
        return '🥪';
      case GameCharacteristic.parking:
        return '🅿️';
      case GameCharacteristic.openStadium:
        return '🏟️☀️';
      case GameCharacteristic.indoorStadium:
        return '🏟️🏠';
      case GameCharacteristic.wifiAccess:
        return '📶';
    }
  }

  String get description {
    switch (this) {
      case GameCharacteristic.cafeteria:
        return 'Coffee and beverages available';
      case GameCharacteristic.shower:
        return 'Shower facilities available';
      case GameCharacteristic.bathroom:
        return 'Bathroom facilities available';
      case GameCharacteristic.restaurant:
        return 'Food and snacks available';
      case GameCharacteristic.parking:
        return 'Parking space available';
      case GameCharacteristic.openStadium:
        return 'Open air stadium';
      case GameCharacteristic.indoorStadium:
        return 'Indoor covered stadium';
      case GameCharacteristic.wifiAccess:
        return 'Free Wi-Fi access';
    }
  }

  String get descriptionAr {
    switch (this) {
      case GameCharacteristic.cafeteria:
        return 'قهوة ومشروبات متوفرة';
      case GameCharacteristic.shower:
        return 'مرافق استحمام متوفرة';
      case GameCharacteristic.bathroom:
        return 'دورات مياه متوفرة';
      case GameCharacteristic.restaurant:
        return 'طعام ووجبات خفيفة متوفرة';
      case GameCharacteristic.parking:
        return 'مواقف سيارات متوفرة';
      case GameCharacteristic.openStadium:
        return 'ملعب في الهواء الطلق';
      case GameCharacteristic.indoorStadium:
        return 'ملعب داخلي مغطى';
      case GameCharacteristic.wifiAccess:
        return 'إنترنت مجاني متوفر';
    }
  }


}
