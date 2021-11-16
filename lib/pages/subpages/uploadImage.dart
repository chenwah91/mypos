
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_app/my_image_upload/service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

import 'bill_detail.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';

class afteUpload extends StatefulWidget {

  final billingData selectedItems_  ;
  final ImageSource imgsource ;
  final pickedFile;

//  final response;
//  final String statusCode;

//  const afteUpload({Key key , this.selectedItems_ , this.response ,this.statusCode}): super(key: key);
  const afteUpload({required Key key , required this.selectedItems_ , required this.imgsource, required this.pickedFile }): super(key: key);
  @override
  _afteUploadState createState() => _afteUploadState();
}

class _afteUploadState extends State<afteUpload> {

  bool isLoading = true;
  double percentage_count = 0;

  void uploadImage(ImageSource imageSource, billingData selectedItems_ ,  pickedFile ) async{

    try {

      isLoading = true;

      if (pickedFile != null) {

        var response = await uploadFile(pickedFile.path,selectedItems_ );


        if (response.statusCode == 200) {
          //get image url from api response
//          imageURL = response.data['user']['image'];
          print(response.data);
          setState(() {
            isLoading = false;
          });


          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message:
              "Success to update payment receipt.".tr(),
            ),
          );

//          Navigator.pop(context);



//          upd_dialog( context );
//          showTopSnackBar(
//            context,
//            CustomSnackBar.success(
//              message:
//              "Success to update payment receipt. ",
//            ),
//          );

        } else if (response.statusCode == 401) {

        } else {

        }
      } else {
        
        
//        int count = 0;
//        Navigator.of(context).popUntil((_) => count++ >= 2);
//        

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>bill_detail(key: UniqueKey(),headtitle: "",selectedItems_: selectedItems_,)));



      }

    } finally {

        setState(() {
          isLoading = false;
        });


    }
  }



   Future<dynamic> uploadFile(filePath , billingData bditems ) async{

    var authToken = "";
    var _userId = "";
    double indcateValue = 0;

    try{

      SharedPreferences pref = await SharedPreferences.getInstance();
      _userId = pref.getString("user_id")!;


      var extension = p.extension(filePath);

      FormData formdata = FormData.fromMap(
          {
            "file": await MultipartFile.fromFile(filePath,filename: '${_userId.toString()}_${bditems.bi_id}_${DateTime.now().millisecondsSinceEpoch}_${ GlobalUserInfomation.GenerateFileName(6)}.$extension'),
            "accountID" : _userId.toString(),
            "bill_id" : bditems.bi_id,
            "apr_bill_gbl" : bditems.gbl_id,
            "apr_bill_type" : bditems.bi_category,
            "apr_termtype" : bditems.bi_termtype,
            "apr_totalamt" : bditems.bi_totalamount,
            "apr_termamt" : bditems.bi_termamount,
          }

      );


      Response response = await Dio().post(
          "https://xeroxlinks.com/mypos/apps/payment_upload.php",
          data: formdata,
          onSendProgress: (int send , int total) {

            setState(() {
              percentage_count = (send / total);
            });

            print("$send / $total");
          }
      );

      return response;


    }on DioError catch(e){
      print("Failed Servie!!!");
      return e.response;

    } catch(e){
      print("error service.darth");
    }

  }

  void initState(){

    super.initState();

     uploadImage( widget.imgsource , widget.selectedItems_ , widget.pickedFile);



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading == true ?
          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(

                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                    minHeight: 2,
                    value: percentage_count,
                    backgroundColor: Colors.white,

                  ),
                  SizedBox(height: 25,),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text("${percentage_count*100} %")
                  ),

                ],
              ),
            ),
          )  : Column(
                children: [
                  Icon(Icons.check_circle , size: 80,color: Colors.green,),
                  SizedBox(height: 20,),
                  Text("Payment Receipt uploaded.".tr()),
                  SizedBox(height: 15,),

                  TextButton(onPressed: (){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  bill_detail(headtitle: " " , selectedItems_: widget.selectedItems_, key: GlobalKey(), )));

                  }, child: Container(

                      padding: EdgeInsets.only(left: 15,right: 15,top: 5 , bottom: 5),
                      decoration: BoxDecoration(
                        
                        border:
                          Border.all(
                            color: Colors.green,
                            width: 2
                          )

                      ),
                      child: Text("Back".tr(),style: TextStyle(color: Colors.green),)
                  ))
                ],
              )
            ],
          )
        ),
      ),
    );
  }


}
