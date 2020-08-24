import 'http.dart';

final WeatherStore weatherStore = WeatherStore();

class WeatherStore{
  int temp;
  String city = "南京";
  String cityID = "101190101";
  String text = '';
  int tempMax;
  int tempMin;

  Future getWeather() async {
    var result1 = await Http().get('https://devapi.heweather.net/v7/weather/now',{
      'location' : cityID,
      'key' : Http.key,
    });

    if(result1 != null){
      temp = int.parse(result1['now']['temp']);
      text = result1['now']['text'];
    }

    var result2 = await Http().get('https://devapi.heweather.net/v7/weather/3d',{
      'location' : '116.41,39.92',
      'key' : Http.key,
    });

    if(result2 != null){
      tempMax = int.parse(result2['daily'][0]['tempMax']);
      tempMin = int.parse(result2['daily'][0]['tempMin']);
    }
  }

  Future updateCity(String s) async {
    var result = await Http().get('https://geoapi.heweather.net/v2/city/lookup',{
      'location' : s,
      'key' : Http.key,
    });
    city = result['location'][0]['name'];
    cityID = result['location'][0]['id'];
    getWeather();
  }
}

