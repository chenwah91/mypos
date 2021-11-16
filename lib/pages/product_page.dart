import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/post.dart';
import 'package:flutter_app/model/productdata.dart';
import 'package:flutter_app/network/network_request.dart';
import 'package:flutter_app/pages/subpages/productDetail.dart';
import 'package:flutter_app/pages/subpages/productsearchfilter.dart';
import 'package:flutter_app/routes/app_pages.dart';
import 'package:flutter_app/routes/app_routes.dart';
//import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/state/state_manage.dart';
import 'package:http/http.dart' as http;
import 'package:progressive_image/progressive_image.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}


int page = 0;
RefreshController _refreshController = new RefreshController(initialRefresh: false);

void _onRefresh() async{
//    await Future.delayed(Duration(seconds:3));
//    var list = await fetchPosts(context , page: 0);
//    context.read(postLoadStates).clear();
//    context.read(postLoadStates).addAll(list);
//
//    setState(() {
//      _refreshController.refreshCompleted();
//    });
}

void _onLoading() async{
//    page++;
//    var list = await fetchPosts(context , page: page);
//    context.read(postLoadStates).clear();
//    context.read(postLoadStates).addAll(list);
//
//    setState(() {
//      _refreshController.refreshCompleted();
//    });


}


Future<List<Post>> _loadData( context , page) async {

  var listPost = await fetchPosts(context,page:page);
//    context.read(postLoadStates).addAll(listPost);
  return listPost;

}


class _ProductPageState extends State<ProductPage> {


  Future ?_future;
  String? category = null;
  List<int> subcategory = [];
  String conditions = "all";
  S2Choice<String>? selectedCategory ;
  List<S2Choice<String>> selectedSubCategory = [];
  S2Choice<String> selectedConditions = S2Choice(value: "all", title: "All");

  void getFromFilterPage(String inputText , List<int> subcategory_, String category_ , String conditions_ ,  S2Choice<String>? selectedcategoryx,  List<S2Choice<String>> selectedcsubategoryx ,  S2Choice<String> selectedconditionsx ){
  //    subcategory: [],category: [],conditions: "new"

    category = category_;
    subcategory = subcategory_;
    conditions = conditions_;
    selectedCategory = selectedcategoryx;
    selectedSubCategory = selectedcsubategoryx;
    selectedConditions = selectedconditionsx;

    print("Category :  $category ");

    if(selectedcategoryx != null){
      print("Selected selectedcategoryx: ${selectedcategoryx.title}" );
    }

    if(selectedcsubategoryx != null){
      print("Selected selectedcsubategoryx : ${selectedcsubategoryx.toString()}" );
    }



    setState(() {

    });

  }


  String convertSubcategortToString( List<S2Choice<String>> subcat){

    List<String> mysubcatList = [];
    if(subcat.length > 0) {

      for(var n in subcat){
        mysubcatList.add(n.value);
      }
      return mysubcatList.toString();

    }else{

      return "";

    }



  }

  int prodpages = 0;
  int prodpages_limit = 20;
  List<productData> myProductList = <productData>[];


  Future<List<productData>> searchBillFunction(int prodpagesxxxx) async {


    String subcategoryConvert = convertSubcategortToString(selectedSubCategory);

    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/product_list.php");
    var data_post = {
      "getProductItemsToken" : "tokenkey",
      "ProductItems_product_condition" : base64.encode(utf8.encode(conditions)).toString(),
      "ProductItems_product_searchkey" : base64.encode(utf8.encode(_searchController.text)).toString(),
      "ProductItems_product_category" : base64.encode(utf8.encode(category.toString())).toString(),
      "ProductItems_product_subcategory" : base64.encode(utf8.encode(subcategoryConvert)).toString(),
      "ProductItems_product_page" : base64.encode(utf8.encode(prodpagesxxxx.toString())).toString(),
      "ProductItems_product_perlimit" : base64.encode(utf8.encode(prodpages_limit.toString())).toString(),
    };

    var data = await http.post(url,body:data_post);

    if(data.statusCode == 200) {

      if (data.body == "nodata") {

        print("searchBillFunction nodata");
        return myProductList;

      }else{
        print("searchBillFunction  ");
        var JsonData = json.decode(data.body);
        print(JsonData.toString());


        for (var ma in JsonData) {

          try{

            productData m = productData.fromJson(ma);
            myProductList.add(m);

          }catch(e){
            print(e.toString() + " < is error");
          }

        }

        return myProductList;



      }




    }else{

      print("searchBillFunction statecode != 200");

      return myProductList;

    }



  }


  void initState(){

    super.initState();
    _future = searchBillFunction(0);

  }


  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double screensizeHeight = MediaQuery.of(context).size.height;
    double screensizeWidth = MediaQuery.of(context).size.width;


    return Consumer(builder : (context,watch,_){


      var items = watch.watch(postLoadStates);

      return Scaffold(
        appBar: null,
        body:  NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll){
        overScroll.disallowIndicator();
        return true;

      }, child: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(

                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25,),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height:60,
                            width: screensizeWidth-80,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) async {
//                          _temp_searchvalue = value;
//
//                          if (searchTime == null) {
//                            searchTime = new Timer(Duration(seconds: 1), () {
//                              filterSearchResults(_temp_searchvalue!);
//                              searchTime?.cancel();
//                            });
//                          } else {
//                            searchTime?.cancel();
//                            searchTime = new Timer(Duration(seconds: 1), () {
//                              filterSearchResults(_temp_searchvalue!);
//                              searchTime?.cancel();
//                            });
//                          }
                              },

                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: "Search Bills",
                                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade500,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500
                                  )
                              ),
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                               // Navigator.pop(context);

                               Navigator.push(context, MaterialPageRoute(builder: (builder)=>productfilter(searchkey: "",subcategory: subcategory,category: category,conditions: conditions,passtoParent: getFromFilterPage,selectedCategory: selectedCategory,selectedSubCategory: selectedSubCategory,selectedConditions: selectedConditions,)));

                              },
                              child: Container(
                                height:60,
                                width: 50,
                                alignment: Alignment.center,
                                child: Icon(FontAwesomeIcons.slidersH,color: Colors.grey[400],size: 28,),
                              ),
                            ),
                            
                          )
                        ],
                      ),
                    ),
                  ],
                ),


              ),
              Container(
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                      future: _future,
                      builder: (context,snapshot){

                        if(snapshot.hasError){

                          return Center( child: Text('${snapshot.error}'),);

                        }else if(snapshot.hasData){

                          return SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (context,mode){
                                Widget body;
                                if(mode == LoadStatus.idle){
                                  body = Text("Pull up to load");
                                }else if ( mode == LoadStatus.loading){

                                  body = CupertinoActivityIndicator();

                                }else if ( mode == LoadStatus.failed){
                                  body = Text("Pull up to load");
                                }else if ( mode == LoadStatus.canLoading){
                                  body = Text("Pull up to load");
                                }else{
                                  body = Text("Pull up to load");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body,),
                                );

                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,


                            child: ListView.builder(
                              itemBuilder: (context,index){

                                return myProductCard(context , index);

//                                return Card(
//                                  child: Center(
//                                    child: Text("Items Title"),
//                                  ),
//
//                                );
                              },
//                              itemExtent: 100.0,
                              itemCount:10,
                            ),

                          );

                        }else{

                          return Center(
                            child: CircularProgressIndicator(),
                          );


                        }

                      },
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
      ));

    });
  }

  Widget myProductCard(BuildContext context, int index){

    List<String> myImageList = [];
    if(myProductList[index].imglink == "" && myProductList[index].imglink == null){

      myImageList = [""];

    }else{

      if(myProductList[index].imglink != null){
        String mylinkslist = myProductList[index].imglink!;
        myImageList = mylinkslist.split(",");

      }else{

        myImageList = [""];
      }



    }


    return Stack(
        alignment: Alignment.center,
        children: [
        GestureDetector(
          onTap: (){
            print("${myProductList[index].pid} > ${myProductList[index].p_name}");
            
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>productdetail(selectedProducyData: myProductList[index])));
 
          },
          child: Container(


            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            
            child: Container(

              decoration: BoxDecoration(

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0,2), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:  BorderRadius.all(Radius.circular(16.0)),
                child: Column(

                    children:[
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),


                        width: MediaQuery.of(context).size.width-20,
                        child:  Stack(
                          children:[

                            myImageList[0] == "" ? Image.asset("assets/images/nophotos.JPG"):
                            ProgressiveImage(
                              placeholder: AssetImage('assets/images/placeholder_image.jpg'),
                              // size: 1.87KB
                              thumbnail:  NetworkImage(myImageList[0]),
                              // size: 1.29MB
                              image:  NetworkImage(myImageList[0]),
                              height: 400,
                              width: 400,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              right: 10,
                              top:10,
                              child: Container(

                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: ( myProductList[index].p_ex_carstatus == "new" ) ? Colors.green : Colors.red ,
                                ),


                                child: ( myProductList[index].p_ex_carstatus == "new" ) ? Text("New",style: TextStyle(color: Colors.white),) : Text("Used",style: TextStyle(color: Colors.white),) ,
                              ),
                            )

                          ]
                        ),
                      ),
                     Container(

                       color: Colors.white,
                       width: MediaQuery.of(context).size.width-20,
                       alignment: Alignment.topLeft,
                       padding: EdgeInsets.only(bottom: 20,left: 10,top: 20,right: 20),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("${myProductList[index].p_name}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                           SizedBox(height: 7,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Quantity : ${myProductList[index].p_quantity}",style: TextStyle(fontSize: 16)),
                               Row(
                                 children: [
                                   Text("RM ",style: TextStyle(color: Colors.redAccent,fontSize: 18, fontWeight: FontWeight.bold),),
                                   Text("${myProductList[index].p_price}",style: TextStyle(color: Colors.redAccent,fontSize: 18, fontWeight: FontWeight.bold),),
                                 ],
                               ),

                             ],
                           )
                         ],
                       ),
                     )
                    ],
                ),
              ),
            ),
          ),

        )
      ],
    );

  }



}
