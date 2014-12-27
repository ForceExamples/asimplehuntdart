import 'package:force/force_browser.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:cargo/cargo_client.dart';

import 'lib/hunt.dart';

@Injectable()
class HuntController {
  String name = "";
  String url = "";
  
  String error = "";

  ForceClient forceClient;
  ViewCollection hunts;
  
  HuntController() {
    forceClient = new ForceClient();
    forceClient.connect();
    
    forceClient.onConnected.listen((ConnectEvent ce) {
        hunts = forceClient.register("simple", new Cargo(MODE: CargoMode.MEMORY));
    });
    
    forceClient.on("notify", (message, sender) {
      error = message.json;
    });
  }

  void update(key, value) {
      var hunt = new Hunt.fromJson(value);
      hunt.point += 1;
      
      hunts.update(key, hunt);
  }
  
  // Send message on the channel
  void send() {
    if(name != "" && url != "") {
      hunts.set(new Hunt(name, url).toJson());
      // reset error field
      error = "";
    }
  }
}

void main() {
  applicationFactory()
      .rootContextType(HuntController)
      .run();
}