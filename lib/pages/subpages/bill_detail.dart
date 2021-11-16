
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/constants.dart';
//import 'package:flutter_app/controller/PaymentController.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_app/model/paymen_record.dart';
import 'package:flutter_app/pages/subpages/pdfViewer.dart';
import 'package:flutter_app/pages/subpages/uploadImage.dart';
import 'package:get/get_core/src/get_main.dart';
//import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemChrome, rootBundle;
import 'package:intl/intl.dart';

import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';


import '../billing_page.dart';
import 'PDFscreen.dart';

class bill_detail extends StatefulWidget {
  final String headtitle;
  final billingData selectedItems_;

  const bill_detail({required Key key, required this.headtitle, required this.selectedItems_})
      : super(key: key);

  @override
  _bill_detail createState() => _bill_detail();

}

class _bill_detail extends State<bill_detail> {
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";
  late Image headImage;

  String userId ="" ;
  double percentage_count = 0.0;

  int _total = 0, _received = 0;
  late http.StreamedResponse _response;

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  Future<File> createFileOfPdfUrl(String billUrl) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
//      final url = "http://www.pdf995.com/samples/pdf.pdf";
      final url = billUrl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));

      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  late String MyPDFurl;

  void initState() {
    getCred();
    headImage = Image.asset("assets/images/bill_detail_photos.png");
    percentage_count = 0.0;
    super.initState();
  }

  void getCred() async {
    String _MyPDFurl = await GlobalUserInfomation().getDomainPdfUrl();

    SharedPreferences pref = await SharedPreferences.getInstance();


    setState(() {
      userId = pref.getString("user_id")!;
      MyPDFurl = _MyPDFurl;
      getPayRecord = _paymentRecord();
    });

    String gblId = widget.selectedItems_.gbl_id!;
    String baseencode = base64.encode(utf8.encode(gblId));
    createFileOfPdfUrl(
            "https://${MyPDFurl}/${widget.selectedItems_.bi_category}.php?gbl=$baseencode")
        .then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });



  }

//  @override
////  void didChangeDependencies() {
////    super.didChangeDependencies();
////
////    precacheImage(headImage.image, context);
////
////  }
  final _scaffoldKey = GlobalKey();


  void upd_addper(){

    setState(() {
      percentage_count = 0.5 ;
//      print("here update : $percentage_count");
//      // we "finish" downloading here
//      if (percentage_count.toStringAsFixed(1) == '1.0' || percentage_count > 1) {
//        print("finish");
//      }
    });

  }

  @override
  Widget build(BuildContext context) {

//    final PaymentController paymentController = Get.put(PaymentController());

    SystemChrome.setEnabledSystemUIOverlays([]);
    return   Scaffold(
           resizeToAvoidBottomInset: false,
            appBar: null,
            key: _scaffoldKey,
            body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: Material(

                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.lightBlueAccent[100]!.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
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
                                            "Bill Info".tr(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black54),
                                          )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (remotePDFpath.isNotEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PDFScreen(
                                                    path: remotePDFpath,
                                                    billdata: widget.selectedItems_,
                                                  ),
                                                ),
                                              );
                                            } else {

                                              showDialog(context: context, builder: (context){
                                               return Dialog(
                                                 shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.all(Radius.circular(20))
                                                 ),
                                                 child: Container(
                                                   height: 200,
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Column(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                     children: [
                                                       Image(image: AssetImage("assets/images/nodata2.png"),width: 150,height: 150),

                                                     ],
                                                 ),
                                                   ),
                                                 ),
                                               );
                                             });

                                            }

//                                Navigator.push(context, MaterialPageRoute(builder: (context)=>billPdfView()));



                                            //  ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content:Text("Enter ${ widget.headtitle } ."),backgroundColor: Colors.blueAccent,));
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 20,
                                            margin: EdgeInsets.only(right: 20),
                                            decoration: BoxDecoration(
                                              color: (remotePDFpath.isNotEmpty
                                                  ? Colors.red
                                                  : Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                child: Text(
                                              "PDF",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
//              color: Colors.lightBlueAccent[100].withOpacity(0.1),
//              child: Image(image: AssetImage("assets/images/bill_detail_photos.png"),opacity: Opacity(0.5),),

                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent[100]!.withOpacity(0.1),
                              image: DecorationImage(
                                opacity: 0.5,
                                image: AssetImage(
                                    "assets/images/bill_detail_photos.png"),
//                  image : Image.asset("assets/images/bill_detail_photos.png"),
                                fit: BoxFit.contain,
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: (widget.selectedItems_.bi_payment_status ==
                                          "paid"
                                      ? 100
                                      : 150),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 0.5,
                                          blurRadius: 15,
                                          offset: Offset(
                                              0, 8), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(20)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${widget.selectedItems_.bi_payment_status}"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: (widget.selectedItems_
                                                    .bi_payment_status ==
                                                "paid"
                                            ? Colors.green
                                            : Colors.red),
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          // child:  Image.asset("assets/images/bill_detail_photos.png"),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.lightBlueAccent[100]!.withOpacity(0.1),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50))),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Expanded(
                                        child: SingleChildScrollView(
                                          padding: const EdgeInsets.only(
                                              left: 35, right: 35, top: 40),
                                          child: Container(
                                            child: Column(
                                              children: [

                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration : BoxDecoration(
                                                        border : Border(
                                                            left: BorderSide(color: Colors.lightBlueAccent ,width: 2)
                                                        ),

                                                      ),
                                                      padding: EdgeInsets.only(left:  10),
                                                      child:  Text(
                                                        "Bill Detail".tr().toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color: Colors.black54,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),

                                                    )

                                                  ],
                                                ),

                                                SizedBox(
                                                  height:30,
                                                ),
//                                          Divider(
//                                            color: Colors.black,
//                                            height: 30,
//                                            indent: 0,
//                                            endIndent: 0,
//                                            thickness: 0.3,
//                                          ),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ID".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "# ${widget.selectedItems_.bi_id!.padLeft(5, '0')}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Type".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "${widget.selectedItems_.bi_category}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Date".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "${ DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.selectedItems_.bi_startdate!))}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Term".toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "${widget.selectedItems_.bi_termname}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Term month".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "${widget.selectedItems_.bi_termouth}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Status".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "${widget.selectedItems_.bi_status}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Amount".tr().toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "RM ${(widget.selectedItems_.bi_termtype == "loan" ? double.parse(widget.selectedItems_.bi_termamount!).toStringAsFixed(2) : double.parse(widget.selectedItems_.bi_totalamount!).toStringAsFixed(2))}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500,),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  height: 30,
                                                  indent: 0,
                                                  endIndent: 0,
                                                  thickness: 0.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Paid".toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "RM ${widget.selectedItems_.totalPaidAmount}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 35,
                                                ),



                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration : BoxDecoration(
                                                          border : Border(
                                                          left: BorderSide(color: Colors.lightBlueAccent ,width: 2)
                                                        ),

                                                      ),
                                                      padding: EdgeInsets.only(left:  10),
                                                      child:  Text(
                                                        "Payment Record".tr().toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color: Colors.black54,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),

                                                    )

                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 25,
                                                ),
                                                PayRecordList(context ),
                                                SizedBox(
                                                  height: 25,
                                                ),




                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(top: 10, left: 15, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (widget.selectedItems_.bi_payment_status == "paid") ? SizedBox() : Expanded(
                                            child: FlatButton(
                                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                onPressed: () {

//                                              Get.bottomSheet(
//                                                Container(
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.white,
//                                                      borderRadius: const BorderRadius.only(
//                                                          topLeft: Radius.circular(16.0),
//                                                          topRight: Radius.circular(16.0)),
//                                                ),
//                                                  child: Wrap(
//                                                    alignment: WrapAlignment.end,
//                                                    crossAxisAlignment: WrapCrossAlignment.end,
//                                                    children: [
//                                                      ListTile(
//                                                        leading: Icon(Icons.camera),
//                                                        title: Text('Camera'),
//                                                        onTap: () {
//                                                          Get.back();
//                                                          paymentController.uploadImage(ImageSource.camera);
//                                                        },
//                                                      ),
//                                                      ListTile(
//                                                        leading: Icon(Icons.image),
//                                                        title: Text('Gallery'),
//                                                        onTap: () {
//                                                          Get.back();
//                                                          paymentController
//                                                              .uploadImage(ImageSource.gallery );
//                                                        },
//                                                      ),
//                                                    ],
//                                                  ),
//                                               )
//                                              );

//                                              ScaffoldMessenger.of(context).showSnackBar(
//                                                  SnackBar(content: Container(
//                                                    //color: Colors.white,
//                                                    decoration: BoxDecoration(color: Colors.green, border: Border.all(width: 1.0, color: Colors.black), borderRadius: BorderRadius.circular(20)),
//                                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 75),
//                                                    child: Padding(
//                                                      padding: const EdgeInsets.all(8.0),
//                                                      child: Text('Yay! A SnackBar!'),
//                                                    ),
//                                                  ), backgroundColor: Colors.transparent, elevation: 1000, behavior: SnackBarBehavior.floating,)
//                                              );



                                                  showModalBottomSheet(context: context, builder: (context){

                                                    return Container(
                                                      color: Color(0xFF737373),
                                                      height: 150,
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
                                                              leading: Icon(Icons.camera),
                                                              title: Text('Camera'.tr()),
                                                              onTap: () async {
//                                                            paymentController.uploadImage(ImageSource.camera,widget.selectedItems_, context );

                                                                final pickedFile_ = await ImagePicker().getImage(source: ImageSource.camera);

                                                                if(pickedFile_  != null ) {

                                                                  Navigator.pushReplacement(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => afteUpload(
                                                                            selectedItems_: widget.selectedItems_ , imgsource: ImageSource.camera, key: GlobalKey(),pickedFile: pickedFile_,)
                                                                      )
                                                                  );


                                                                }else{

                                                                  showDialog(context: context, builder: (context){
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                                                      ),
                                                                      child: Container(
                                                                        height: 200,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text("No File Select".tr(),style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                                                                              SizedBox(height: 10,),
                                                                              Text("Upload Receipt cancel".tr(),style: TextStyle(fontSize: 12 , color: Colors.grey),)

                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });


                                                                }
                                                              },
                                                            ),

                                                            Divider(
                                                              height: 5,
                                                            ),


                                                            ListTile(
                                                              leading: Icon(Icons.image),
                                                              title: Text('Gallery'.tr()),
                                                              onTap: () async {
//                                                            paymentController.uploadImage(ImageSource.gallery , widget.selectedItems_ , context );


                                                                final pickedFile_ = await ImagePicker().getImage(source: ImageSource.gallery);

                                                                if(pickedFile_ != null) {

                                                                  Navigator.pushReplacement(context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => afteUpload(
                                                                              selectedItems_: widget.selectedItems_ , imgsource: ImageSource.gallery,key: GlobalKey(),pickedFile: pickedFile_)
                                                                      )
                                                                  );



                                                                }else{

                                                                  showDialog(context: context, builder: (context){
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                                                      ),
                                                                      child: Container(
                                                                        height: 200,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text("No File Select".tr(),style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                                                                              SizedBox(height: 10,),
                                                                              Text("Upload Receipt cancel".tr(),style: TextStyle(fontSize: 12 , color: Colors.grey),)

                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });

                                                                }

                                                              },
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    );

                                                  });



//                                              Get.bottomSheet(
//                                                Container(
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    borderRadius: const BorderRadius.only(
//                                                        topLeft: Radius.circular(16.0),
//                                                        topRight: Radius.circular(16.0)),
//                                                  ),
//                                                  child: Wrap(
//                                                    alignment: WrapAlignment.end,
//                                                    crossAxisAlignment: WrapCrossAlignment.end,
//                                                    children: [
//
//                                                      ListTile(
//                                                        leading: Icon(Icons.camera),
//                                                        title: Text('Camera'),
//                                                        onTap: () {
//                                                          paymentController.uploadImage(ImageSource.camera);
//                                                        },
//                                                      ),
//
//                                                      ListTile(
//                                                        leading: Icon(Icons.image),
//                                                        title: Text('Gallery'),
//                                                        onTap: () {
//                                                          paymentController.uploadImage(ImageSource.gallery);
//                                                        },
//                                                      ),
//
//                                                    ],
//                                                  ),
//                                                ),
//                                              );

                                                },
                                                textColor: Colors.black54,
                                                child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color: Colors.black54,
                                                          width: 1)),
                                                  child: Row(

                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,

                                                    children: [
                                                      Icon(Icons.file_upload),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Upload Payment".tr()),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          (widget.selectedItems_.bi_payment_status == "paid") ? Expanded(
                                            child: FlatButton(

                                                onPressed: () {

                                                  if (remotePDFpath.isNotEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PDFScreen(
                                                          path: remotePDFpath,
                                                          billdata: widget.selectedItems_,
                                                        ),
                                                      ),
                                                    );
                                                  } else {

                                                    showDialog(context: context, builder: (context){
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                                        ),
                                                        child: Container(
                                                          height: 200,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Image(image: AssetImage("assets/images/nodata2.png"),width: 150,height: 150),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });

                                                  }

                                                },
                                                textColor: Colors.black54,
                                                child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color: Colors.black54,
                                                          width: 1)),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.visibility),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("View PDF".tr())
                                                    ],
                                                  ),
                                                )),
                                          ) :  FlatButton(

                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              onPressed: () {

                                                if (remotePDFpath.isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PDFScreen(
                                                        path: remotePDFpath,
                                                        billdata: widget.selectedItems_,
                                                      ),
                                                    ),
                                                  );
                                                } else {

                                                  showDialog(context: context, builder: (context){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                                      ),
                                                      child: Container(
                                                        height: 200,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Image(image: AssetImage("assets/images/nodata2.png"),width: 150,height: 150),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });

                                                }

                                              },
                                              textColor: Colors.black54,
                                              child: Container(
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Colors.black54,
                                                        width: 1)),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.visibility),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("View PDF".tr())
                                                  ],
                                                ),
                                              )),

                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 20,)
                                  ],
                                ),

//                    Positioned(
//                      bottom: 25,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        padding: EdgeInsets.only(top: 15,left:15,right: 20),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: [
//                            Expanded(
//                              child: FlatButton(
//                                  onPressed: (){},
//                                  textColor: Colors.black54,
//
//                                  child: Container(
//                                    padding: EdgeInsets.all(12),
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(10),
//                                      border: Border.all(
//                                        color: Colors.black54,
//                                        width: 1
//                                      )
//                                    ),
//                                    child: Row(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      mainAxisAlignment: MainAxisAlignment.center,
//                                      children: [
//                                        Icon(Icons.file_upload),
//                                        SizedBox(width: 5,),
//                                        Text("Upload Payment")
//                                      ],
//                                    ),
//
//                                  )),
//                            ),
//
//                            FlatButton(
//                                onPressed: (){},
//                                textColor: Colors.black54,
//                                child: Container(
//                                  padding: EdgeInsets.all(12),
//                                  decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(10),
//                                      border: Border.all(
//                                          color: Colors.black54,
//                                          width: 1
//                                      )
//                                  ),
//                                  child: Row(
//                                    children: [
//                                      Icon(Icons.visibility),
//                                      SizedBox(width: 5,),
//                                      Text("View")
//                                    ],
//                                  ),
//
//                                )),
//                          ],
//                        ),
//                      ),
//                    ),


//                          Positioned(
//                            top: 0,
//                            height: 150,
//                            child: SizedBox(
//                              width: 100,
//                              height: 100,
//                              child: FlatButton(
//                                child: Text("CLick hre"),
//                                color: Colors.lightBlueAccent,
//                                onPressed: (){
////                                  paymentController.uploadImage(ImageSource.gallery);
//
//                                  showModalBottomSheet(context: context, builder: (context){
//
//                                                return Container(
//                                                  color: Color(0xFF737373),
//                                                  height: 150,
//                                                  child: Container(
//                                                    padding: EdgeInsets.all(15),
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.white,
//                                                      borderRadius: const BorderRadius.only(
//                                                          topLeft: Radius.circular(20.0),
//                                                          topRight: Radius.circular(20.0)),
//                                                    ),
//                                                    child: Wrap(
//                                                      alignment: WrapAlignment.end,
//                                                      crossAxisAlignment: WrapCrossAlignment.end,
//                                                      children: [
//
//                                                        ListTile(
//                                                          leading: Icon(Icons.camera),
//                                                          title: Text('Camera'),
//                                                          onTap: () {
//                                                            paymentController.uploadImage(ImageSource.camera);
//                                                          },
//                                                        ),
//
//                                                        Divider(
//                                                          height: 5,
//
//                                                        ),
//
//                                                        ListTile(
//                                                          leading: Icon(Icons.image),
//                                                          title: Text('Gallery'),
//                                                          onTap: () {
//                                                            paymentController.uploadImage(ImageSource.gallery);
//                                                          },
//                                                        ),
//
//
//
//                                                      ],
//                                                    ),
//                                                  ),
//                                                );
//
//                                  });
//                                },
//
//                              ),
//                            ),
//                          )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
    );

  }

  List<payRcdItems> prcdItems = <payRcdItems>[];
  Future? getPayRecord ;

  Future<List<payRcdItems>> _paymentRecord() async{
    prcdItems.clear();
    await Future.delayed(Duration(milliseconds: 1000));

    print(userId);
    print(widget.selectedItems_.bi_id);

    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/get_paymentrecord.php");
    var data_post = {
      "accountID" :  userId ,
      "billId" :   widget.selectedItems_.bi_id

    };

    var data = await http.post(url,body:data_post);


    if(data.statusCode == 200){

      if(data.body == "no_data" ) {
        prcdItems.clear();
        return [];

      }else {

        var JsonData = json.decode(data.body);

        for (var ma in JsonData) {
          //items.add(billingData.fromJson(JsonData));
          try {
//            billingData m = billingData(
//                ma["bi_id"], ma["bi_category"], ma["bi_totalamount"]);
//            print(ma);
            payRcdItems m = payRcdItems.fromJson(ma);
            prcdItems.add(m);

          } catch (e) {
            print(e.toString() + " < is json");
          }
//        items.add( billingData.fromJson(ma) );
        }

      }
      return prcdItems;
    }else{

      prcdItems.clear();
      return [];
    }


  }



  PayRecordList( BuildContext cont) {

    return Container(
      height: 100,
      child: FutureBuilder(
        future: getPayRecord,
        builder: (cont , snapshot){

          if (snapshot.hasError) print(snapshot.error);
         if(snapshot.connectionState == ConnectionState.done){

           return snapshot.hasData
               ?  _paymentRecordData(snapshot.data)
               :  Center(
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: SizedBox(
                 child: Container(
                   child: Column(
                     children: [

                       Padding(
                         padding: const EdgeInsets.only(top: 10),
                         child: Text("- No Record Found -".tr(), style: TextStyle(color: Colors.grey[600],fontSize: 12,letterSpacing: 1),),
                       )
                     ],
                   ),
                 ),
               ),
             ),
           );


         }else{

           return Center(child: CircularProgressIndicator());

         }



        },


      ),
    );



  }

  Widget _paymentRecordData(mydata) {


      return  Container(

        child: ListView.builder(
          itemCount: mydata.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return Container(
              width: 170,
              decoration: BoxDecoration(
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),

                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Text("RM",style: TextStyle(fontSize: 10),),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 15, 0, 5),
                            child: Text("${prcdItems[index].pay_amount}",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),

                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)
                            ),
                            color: prcdItems[index].pay_status == "active" ? Colors.green[100] :Colors.red.withOpacity(0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${prcdItems[index].pay_status == "active" ? "Success" : "Pending" }",style: TextStyle(color: prcdItems[index].pay_status == "active" ? Colors.green : Colors.white , fontWeight: FontWeight.bold),),
                              SizedBox(
                                height: 3,
                              ),
                              Text("${ DateFormat('yyyy-MM-dd').format(DateTime.parse(prcdItems[index].pay_createdate!))}",style: TextStyle(fontSize: 11, color: prcdItems[index].pay_status == "active" ? Colors.green : Colors.white , fontWeight: FontWeight.bold),)
                            ],
                          ),



                        ),
                      )
                    ],
                  ),
                ),

                color: Colors.white,

              ),
            );
          },
        ),
      );

  }



}
