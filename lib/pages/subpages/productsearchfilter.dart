
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter_app/model/categoryList.dart';
import 'package:flutter_app/model/subCategoryList.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;

import '../product_page.dart';


class productfilter extends StatefulWidget {

  final String searchkey ;
  final String? category;
  final List<int>? subcategory;
  final String conditions ;
  final passtoParent;
  final S2Choice<String>? selectedCategory;
  final List<S2Choice<String>> selectedSubCategory;
  final S2Choice<String> selectedConditions;
  productfilter({Key? key, required this.searchkey, required this.category, required this.subcategory, required this.conditions, this.passtoParent, this.selectedCategory, required this.selectedSubCategory, required this.selectedConditions }):super(key: key);

  @override
  _productfilterState createState() => _productfilterState();
}

class _productfilterState extends State<productfilter> {



  String? category = null;
  List<int>? subcategory = [];
  String? conditions;

  String value = 'flutter22';
  List<S2Choice<String>> optionsCategory = [];
  List<S2Choice<String>> optionsSubCategory = [];
  S2Choice<String>? selectedCategoryChoise;
  S2Choice<String>? selectedConditionChoice;
  List<S2Choice<String>> selectedSubCategoryChoise = [];
  List<S2Choice<String>> optionsConditions = [
    S2Choice(value: "all", title: "all"),
    S2Choice(value: "new", title: "New"),
    S2Choice(value: "old", title: "old"),
  ];

  bool _changeSubcategoryLoad = true;

  GlobalKey mySubcatkey = GlobalKey();

  @override
  void initState() {
    super.initState();

    subcategory = widget.subcategory;
    category = widget.category;
    conditions = widget.conditions;
    selectedCategoryChoise = widget.selectedCategory;
    selectedConditionChoice = widget.selectedConditions;
    selectedSubCategoryChoise = widget.selectedSubCategory;



    loadCategoryData(widget.category);

    if(category != null){

      loadsubcategory(category);
      setState(() {
        _changeSubcategoryLoad = false;
      });


    }




  }

  Future<void> loadCategoryData(String? selected) async {

//    SharedPreferences pref = await SharedPreferences.getInstance();
//    String myUserID = await pref.getString("user_id")!;

    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/product_list.php");
    var data_post = {
      "getProductCategoryInfo" : "tokenkey",
    };

    var data = await http.post(url,body:data_post);

    if(data.statusCode == 200){

      if (data.body == "nodata" ) {




      }else if(data.body == ""){



      }else{

        var JsonData = json.decode(data.body);
        print(JsonData.toString());
        optionsCategory.clear();

        for (var ma in JsonData) {

          try{

            categoryItems m = categoryItems.fromJson(ma);

            //  S2Choice<String>(value: 'ion', title: 'Ionic')
            optionsCategory.add(S2Choice<String>(value: m.pc_id.toString(), title: m.pc_name));
          }catch(e){
            print(e.toString() + " < is error");
          }

        }





      }


    }else{

      print("cant connect server...");


    }



  }


  Future<List<S2Choice<String>>> loadsubCategoryReturn() async {


    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/product_list.php");
    var data_post = {
      "getProductSubCategoryInfo" : "tokenkey",
      "getProductSubCategoryCategoryId" : base64.encode(utf8.encode(category!)).toString(),
    };

    var data = await http.post(url,body:data_post);

    if(data.statusCode == 200){

      if (data.body == "nodata" ) {


        print("NODATA");
        return [];
      }else if(data.body == ""){

        print("IS EMPTY");
        return [];
      }else{

        var JsonData = json.decode(data.body);
        print("is loadsubcategory > ${JsonData.toString()}");
        optionsSubCategory.clear();

        for (var ma in JsonData) {

          try{

            subCategoryItems m = subCategoryItems.fromJson(ma);

            //  S2Choice<String>(value: 'ion', title: 'Ionic')
            setState(() {
              optionsSubCategory.add(S2Choice<String>(value: m.pcs_id.toString(), title: m.pcs_name));

            });

          }catch(e){
            print(e.toString() + " < is error");
          }

        }

        return optionsSubCategory;

      }


    }else{

      print("cant connect server...");
      return [];

    }

  }

  Future<void> loadsubcategory(String? seleCategoryID) async {
    print("in loadsubcategory load : ${seleCategoryID}");
    if(seleCategoryID == null ){

      return;

    }


    print("in loadsubcategory load run load");

    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/product_list.php");
    var data_post = {
      "getProductSubCategoryInfo" : "tokenkey",
      "getProductSubCategoryCategoryId" : base64.encode(utf8.encode(seleCategoryID)).toString(),
    };

    var data = await http.post(url,body:data_post);

    if(data.statusCode == 200){

      if (data.body == "nodata" ) {


        print("NODATA");

      }else if(data.body == ""){

        print("IS EMPTY");

      }else{

        var JsonData = json.decode(data.body);
        print("is loadsubcategory > ${JsonData.toString()}");
        optionsSubCategory.clear();

        for (var ma in JsonData) {

          try{

            subCategoryItems m = subCategoryItems.fromJson(ma);

            //  S2Choice<String>(value: 'ion', title: 'Ionic')
            setState(() {
              optionsSubCategory.add(S2Choice<String>(value: m.pcs_id.toString(), title: m.pcs_name));

            });

          }catch(e){
            print(e.toString() + " < is error");
          }

        }
        print("sub > ${optionsCategory.toString()}");
        print("sub > ${optionsSubCategory.toString()}");

        setState(() {

        });

      }


    }else{

      print("cant connect server...");


    }


  }


  Widget defaultselected(){

    return Container(
      padding: EdgeInsets.only(left: 16,right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Subcategory",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 15),),
          Text("Please select category",style: TextStyle(color: Colors.grey,fontSize: 13),),
        ],
      ),


    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 25,right: 25 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //awesome_select 5.0.5
              //https://github.com/davigmacode/flutter_smart_select/blob/master/example/lib/features_choices/choices_theme.dart
              Container(

                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15,right: 25, bottom: 15),
                      child: Text("Search Filter",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      alignment: Alignment.centerLeft,
                    ),
                    SmartSelect<String>.single(
                      title: "Category",
                      choiceConfig: S2ChoiceConfig(
                        style: S2ChoiceStyle(
                          color: Colors.deepPurple
                        )
                      ),
                    selectedChoice: selectedCategoryChoise ,
                    modalConfig: S2ModalConfig(
                    type: S2ModalType.fullPage,
                    useFilter: true,
                    style: S2ModalStyle(
                      backgroundColor: Colors.white,
                    ),),
                      placeholder: "Select Category",
                      modalHeaderStyle: S2ModalHeaderStyle(
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(color: Colors.black),
                        iconTheme: IconThemeData(color: Colors.black),
                        elevation: 0
                      ),

                      onModalOpen: (state){
                        _changeSubcategoryLoad = true;
                        setState(() {

                        });
                        print("opennnn!!!!");
                      },
                      choiceItems: optionsCategory,
                      onChange: (state){

                        if(state.value != null){


                          selectedCategoryChoise = S2Choice<String>(value: state.value!, title:state.title);
                          category = state.value!;
                          print("select category : ${state.value!}");

                          optionsSubCategory.clear();
                          loadsubcategory(state.value!);
                          loadsubCategoryReturn();


                          setState(() {
                            selectedSubCategoryChoise.clear();
                            _changeSubcategoryLoad = false;
                          });



                        }else{
                          print("no selected");
                        }



                        setState((){
                          value = state.value!;
                        });
                      },


                    ),

                    ( _changeSubcategoryLoad ) ?  defaultselected()  :  new SmartSelect<String>.multiple(
                      key: mySubcatkey,
                      title: "Subcategory",
                      selectedChoice: selectedSubCategoryChoise,
                      choiceConfig: S2ChoiceConfig(
                          style: S2ChoiceStyle(
                              color: Colors.deepPurple
                          )
                      ),
                      modalConfig: S2ModalConfig(
                        type: S2ModalType.fullPage,
                        useFilter: true,
                        style: S2ModalStyle(
                          backgroundColor: Colors.white,
                        ),),
                      placeholder: "Select Subcategory",
                      modalHeaderStyle: S2ModalHeaderStyle(
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(color: Colors.black),
                          iconTheme: IconThemeData(color: Colors.black),
                          elevation: 0
                      ),

                      choiceLoader: (_){
                        return loadsubCategoryReturn();
                      },
                      onChange: (state){

                        print(state?.value.toString());
                        if(state != null && state.length > 0){

                          if(selectedSubCategoryChoise != null){
                            selectedSubCategoryChoise.clear();
                            print("   selectedSubCategoryChoise.clear() ");
                          }


                          for (var ma in state.choice!) {

                            selectedSubCategoryChoise.add(S2Choice(value: ma.value, title: ma.title));

                            print("added ${ma.value} with ${ma.title}");
                          }
                          setState(() {

                          });

                        }


                      },


                    ),
                    SmartSelect<String>.single(
                      title: "Conditions",
                      choiceConfig: S2ChoiceConfig(
                          style: S2ChoiceStyle(
                              color: Colors.deepPurple
                          )
                      ),
                      selectedChoice: selectedConditionChoice ,
                      modalConfig: S2ModalConfig(
                        type: S2ModalType.fullPage,
                        useFilter: true,
                        style: S2ModalStyle(
                          backgroundColor: Colors.white,
                        ),),
                      placeholder: "Select Conditions",
                      modalHeaderStyle: S2ModalHeaderStyle(
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(color: Colors.black),
                          iconTheme: IconThemeData(color: Colors.black),
                          elevation: 0
                      ),

                      onModalOpen: (state){

                        setState(() {

                        });

                      },
                      choiceItems: optionsConditions,
                      onChange: (state){

                        if(state.value != null){

                          selectedConditionChoice = S2Choice<String>(value: state.value!, title:state.title);

                          setState(() {


                          });


                        }else{
                          print("no selected");
                        }




                      },


                    ),





                  ],
                ),

              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width-80,

                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  onPressed: (){

                    print(" selectedSubCategoryChoise filter > ${selectedSubCategoryChoise.length}");

                    //String inputText , List<int> subcategory_, int category_ , String conditions_ ,  S2Choice<String>? selectedcategory
                    widget.passtoParent("",<int>[],category,conditions,selectedCategoryChoise,selectedSubCategoryChoise,selectedConditionChoice);
                    Navigator.pop(context);


                  },
                  color: Colors.deepPurpleAccent,
                  child: Text("Apply",style: TextStyle(color: Colors.white),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0),
                width: MediaQuery.of(context).size.width-80,

                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  onPressed: (){


                    Navigator.pop(context);
                   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>ProviderScope(child: ProductPage(),)), (route) => false);

                  },
                  color: Colors.orangeAccent,
                  child: Text("Back",style: TextStyle(color: Colors.white),),
                ),
              )


            ],

          ),

        ),
      ),
    );
  }
}
