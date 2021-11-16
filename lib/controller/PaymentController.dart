import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_app/my_image_upload/service.dart';
import 'package:flutter_app/pages/subpages/bill_detail.dart';
import 'package:flutter_app/pages/subpages/uploadImage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class PaymentController extends GetxController{

  var isLoading = false.obs;
  var imageURL = '';

  void uploadImage(ImageSource imageSource, billingData selectedItems_ , BuildContext context  ) async{


    try {



      final pickedFile = await ImagePicker().getImage(source: imageSource);
      isLoading(true);
      if (pickedFile != null) {

        var response = await ImageService.uploadFile(pickedFile.path,selectedItems_,context );


        if (response.statusCode == 200) {
          //get image url from api response
//          imageURL = response.data['user']['image'];
          print(response.data);

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
          Get.snackbar('Failed', 'Error Code: ${response.statusCode}',
              margin: EdgeInsets.only(top: 5,left: 10,right: 10));
        }
      } else {
        Get.snackbar('Failed', 'Image not selected',
            margin: EdgeInsets.only(top: 5,left: 10,right: 10));
      }
    } finally {

      isLoading(false);
    }
  }



  }
