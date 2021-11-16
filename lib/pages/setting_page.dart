
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/post.dart';
import 'package:flutter_app/network/network_request.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/subpages/change_password.dart';
import 'package:flutter_app/pages/subpages/general_setting.dart';
// ignore: deprecated_member_use
//import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/state/state_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _settingpage createState() => _settingpage();
}

class _settingpage extends State<SettingPage> {


  Locale? _locale;


  @override
  Widget build(BuildContext context) {

    print(context.locale.toString());

    return MaterialApp(

      home: mySettingScaffold()
    );
  }


}

class mySettingScaffold extends StatefulWidget {
  @override
  _mySettingScaffoldState createState() => _mySettingScaffoldState();
}

class _mySettingScaffoldState extends State<mySettingScaffold> {



  List<String>? isSelectLanguage;

  void initState(){

    super.initState();
    loadSetting();


  }

  Future<void> loadSetting() async {

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    if(sharepref.containsKey("lang")){


      isSelectLanguage = await sharepref.getStringList("lang");
      print("is set ${isSelectLanguage.toString()}");
    }else{

      isSelectLanguage = ["true","false","false"];
      List<String> setPf = ["true","false","false"];
      await sharepref.setStringList("lang", setPf);

      print("is OT set ${isSelectLanguage.toString()}");


    }


  }


  Future<Null> updated(StateSetter updateState , List<String> updateList) async {

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    await sharepref.setStringList("lang", updateList);
    print("is updated set ${isSelectLanguage.toString()}");

    updateState(() {

      isSelectLanguage = updateList;

      if(isSelectLanguage?[0] == "true"){
        context.locale = Locale("en");
      }else if(isSelectLanguage?[1] == "true"){
        context.locale = Locale("zh");
      }else if(isSelectLanguage?[2] == "true"){
        context.locale = Locale("ms");
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10 , right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 35,),
              Padding(
                padding: const EdgeInsets.only(left: 10,bottom:10),
                child: Text("Setting",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),).tr(),
              ),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.lock_outline , color: Colors.grey,),
                      title: Text("ChangePassword").tr(),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>changepassword()));

                      },
                    ),
                    ListTile(
                        leading: Icon(FontAwesomeIcons.language , color: Colors.grey,),
                        title: Text("Language").tr(),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){

                          showModalBottomSheet(context: context, builder: (context){

                            return StatefulBuilder(
                                builder: (context,state ) {
                                  return Container(
                                    color: Color(0xFF737373),
                                    height: 200,
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0)),
                                      ),
                                      child: Wrap(
                                        alignment: WrapAlignment.end,
                                        crossAxisAlignment: WrapCrossAlignment.end,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.language),
                                            title: Text("English"),
                                            trailing: isSelectLanguage?[0] == "true" ? Icon(Icons.done,color: Colors.purple,) : null,
                                            onTap: (){

                                              updated(state, ["true","false","false"]);
                                            },
                                          ),

                                          ListTile(
                                            leading: Icon(Icons.language),
                                            title: Text("中文"),
                                            trailing: isSelectLanguage?[1] == "true"  ? Icon(Icons.done,color: Colors.purple,) : null,
                                            onTap: (){

                                              updated(state, ["false","true","false"]);



                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.language),
                                            title: Text("Malay"),
                                            trailing: isSelectLanguage?[2] == "true" ? Icon(Icons.done,color: Colors.purple,) : null,
                                            onTap: (){

                                              updated(state, ["false","false","true"]);
                                            },
                                          ),

                                        ],
                                      ),
                                    ),

                                  );
                                }
                            );

                          });

                        })
                    ,
                    ListTile(
                      leading: Icon(FontAwesomeIcons.route , color: Colors.grey,),
                      title: Text("General").tr(),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>generalSetting()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded , color: Colors.grey,),
                      title: Text("Logout").tr(),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {

                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        await preferences.clear();

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);



                      },
                    )
                  ],
                ),
              )


            ],

          ),
        ),

      ),
    );
  }
}

