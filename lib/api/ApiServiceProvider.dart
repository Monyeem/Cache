import 'dart:convert';
import 'dart:io';

import 'package:future_builder_app/pojo/Response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiServiceProvider {
  Future<Response> getUser(String catId) async {
    String fileName = "userdata.json";

    var dir = await getTemporaryDirectory();

    File file = new File(dir.path + "/" + fileName);
    if (file.existsSync()) {
      print("Loading from cache");
      // var appDir = (await getTemporaryDirectory()).path + fileName;
      // new Directory(appDir).delete(recursive: true);
      var jsonData = file.readAsStringSync();
      Response response = Response.fromJson(json.decode(jsonData));
      return response;
    } else {
      print("Loading from API");
      String _BASE_URL =
          "https://app.ringersoft.com/api/ringersoftfoodapp/test-category/$catId?fbclid=IwAR3OfylOShIlzWs7pQEt5kLSyBfQhLrjhlWcbA4P6GIr-GUj0WDQaDgjTd0";

      var response = await http.get(_BASE_URL);

      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        Response res = Response.fromJson(json.decode(jsonResponse));
        print(res);
        //save json in local file
        file.writeAsStringSync(jsonResponse, flush: true, mode: FileMode.write);

        return res;
      }
    }
  }
}
