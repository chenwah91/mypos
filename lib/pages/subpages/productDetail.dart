
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/productdata.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:photo_view/photo_view.dart';

class productdetail extends StatefulWidget {
  final productData selectedProducyData;

  const productdetail({Key? key, required this.selectedProducyData}) : super(key: key);



  @override
  _productdetailState createState() => _productdetailState();
}

class _productdetailState extends State<productdetail> {


  int photoIndex = 0;
  String? htmlContent;

  void initState(){

    super.initState();

    htmlContent = widget.selectedProducyData.p_desc;




  }


  void setPhotoIndex(int newIndex){
    photoIndex = newIndex;
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {



    List<String> myImageList = [];
    if(widget.selectedProducyData.imglink == ""){

      myImageList = [""];

    }else{

      if(widget.selectedProducyData.imglink != null){
        String mylinkslist = widget.selectedProducyData.imglink!;
        myImageList = mylinkslist.split(",");

      }else{

        myImageList = [""];
      }
    }



    return Scaffold(
      appBar: null,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },

        child:  Container(
          child: Column(
            children: [
              Container(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.zero,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 0, top: 13),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                  minWidth: 15,
                                  onPressed: () =>
                                  {Navigator.pop(context)},
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  )),

                              Expanded(
                                child: SizedBox(
//                                 child: Text("${ widget.headtitle } ", style: TextStyle(fontSize: 18), )
                                    child: Text(
                                      "${widget.selectedProducyData.p_name!}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54),
                                    ) ),
                              ),

                            ],
                          )
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: (myImageList[0] == "" )? Image.asset("assets/images/nophotos.JPG") : GestureDetector(
                            onTap: (){
                              print("currentIndex : $photoIndex");

                            },
                            child: CarouselSlider(

                              options: CarouselOptions(
                                  height: 300.0,
                                onPageChanged: (index, reason){

                                    print("photo swip > index $index");
                                    setPhotoIndex(index);


                                }
                              ),

                              items: myImageList.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      child: ClipRRect(
                                          borderRadius:  BorderRadius.all(Radius.circular(20.0)),
                                          child:  Container(
                                            width: MediaQuery.of(context).size.width,

                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:  BorderRadius.all(Radius.circular(20.0)),
                                            ),
                                            child: ProgressiveImage(
                                              placeholder: AssetImage('assets/images/placeholder_image.jpg'),
                                              // size: 1.87KB
                                              thumbnail:  NetworkImage(i),
                                              // size: 1.29MB
                                              image:  NetworkImage(i),

                                              height: 400,
                                              width: 400,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [

                              Container(

                                padding: EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.selectedProducyData.p_name!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [


                                            Text("Quantity : ${widget.selectedProducyData.p_quantity}" ),
                                            SizedBox(width: 15,),
                                            widget.selectedProducyData.p_ex_carstatus == "new" ?
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.green
                                                ),
                                                child: Text("${widget.selectedProducyData.p_ex_carstatus}".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 11),)
                                            )
                                                : Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.orange
                                                ),
                                                child: Text("used".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 11),)
                                            ),

                                          ],
                                        ),
                                        Text("RM ${widget.selectedProducyData.p_price!}",style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                  ],
                                ) ,
                              ),

                              Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.selectedProducyData.p_shortdesc == "" ? "-":widget.selectedProducyData.p_shortdesc!,)
                              ),
                              SizedBox(height:10,),

                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("Description ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                                padding: EdgeInsets.only(bottom: 15),

                              ),
                              SizedBox(height:10,),

                              RichText(text: HTML.toTextSpan(context, htmlContent!,defaultTextStyle: TextStyle(fontSize: 10)) ,softWrap: true,  ),
                              SizedBox(height:20,),
                            ],
                          ),
                        )


                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
