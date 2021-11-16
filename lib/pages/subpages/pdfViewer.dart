import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

import 'package:path_provider/path_provider.dart';



class billPdfView extends StatefulWidget {
  @override
  _billPdfViewState createState() => _billPdfViewState();
}

class _billPdfViewState extends State<billPdfView> {

  String urlPDFPath  = "";
  int _totalpages = 0;
  int _currentpages = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController ;

  void initState(){

    getPDFfromURL("https://giver.com.my/doc/termcondition.pdf").then((value){
      print("hallo value.path > " + value.path);
      setState(() {
        urlPDFPath = value.path;
      });

      print("hallo urlPDFPath.path > " + urlPDFPath);
    });

    super.initState();

  }

  Future<File> getPDFfromURL(String Url) async{


    try{
      Uri url = Uri.parse(Url);
      var data = await http.get(url);
      var bytes =data.bodyBytes;
      print("hallo Url.path > $Url");
      var dir =await getApplicationDocumentsDirectory();

      print("hallo dir.path > $dir");
      File file = File("${dir.path}/mypdfonline.pdf");
      print("hallo file.path > ${file.path}");
      File assetFile = await file.writeAsBytes(bytes);
      print("hallo assetFile.path > ${assetFile.absolute}");
      return assetFile;


    }catch(e){
      throw Exception("Error opening asset file");
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          height: 650,
          child: Column(
            children: [
              Expanded(

                child: PDFView(
                  filePath: urlPDFPath,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  onError: (e){
                      print(e);
                  },
                  onRender: (_pages){

                    _totalpages = _pages!;
                    pdfReady = true;
                  },
                  onViewCreated: (PDFViewController vc){
                    _pdfViewController = vc;


                  },
                  onPageChanged: (int? page , int? total){
                    print("hallo");
                    setState(() {

                    });
                  },
                  onPageError: (pages , e){

                  },

                ),
              ),
              !pdfReady?Center(child: CircularProgressIndicator(),):Offstage(),

            ],
          ),
          
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _currentpages > 0 ?FloatingActionButton.extended(
            backgroundColor: Colors.red,
            label: Text("Go to ${_currentpages-1}"),
            onPressed: () {
              _currentpages -= 1;
              _pdfViewController.setPage(_currentpages);
            }
          ):Offstage(),

          _currentpages < _totalpages?FloatingActionButton.extended(
              backgroundColor: Colors.green,
              label: Text("Go to ${_currentpages+1}"),
              onPressed: () {
                _currentpages += 1;
                _pdfViewController.setPage(_currentpages);
              }
          ):Offstage(),




        ],
      ),
    );
  }
}

