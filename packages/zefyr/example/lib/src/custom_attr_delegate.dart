import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

class CustomAttrDelegate implements ZefyrAttrDelegate {
  CustomAttrDelegate();

  @override
  void onLinkTap(String value) async{
    print('the link is: $value');
     if (await canLaunch(value)) {
        await launch(value, forceSafariVC: false);
      } else {
        print('unable to launch url');
        // throw 'Could not launch $url';
      }
  }
}