
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';


class PDFScreen extends StatefulWidget {
  final String? path;
  final billingData? billdata ;

  PDFScreen({Key? key, this.path , this.billdata}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? _total = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  bool _firstLoad = false;


  void initState() {

    super.initState();
    initPDF();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  null,
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.zero,
                      height: 50,
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 0,top: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              minWidth: 15,
                              onPressed: ()=>{
                                Navigator.pop(context)
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child:  Icon(Icons.arrow_back_ios, size: 20,)),

                          Expanded(
                            child: SizedBox(
                                child: Text("${ (widget.billdata!.bi_id)  } ", style: TextStyle(fontSize: 18), )
                            ),
                          ),


                        ],


                      )
                  ),

                ],
              ),
            ),
          ),

          Container(

            child: Column(
              children: <Widget>[
                Expanded(
                  child: ( !_firstLoad ? Center(



                  ) : PDFView(
                    filePath: widget.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage!,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation:
                    false, // if set to true the link is handled in flutter
                    onRender: (_pages)  {
                      setState(()  {
                        pages = _pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {

                      _controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String? uri) {
                      print('goto uri: $uri');
                    },
                    onPageChanged: (int? page, int? total) {
                      print('page change: $page/$total');
                      setState(() {
                        _total = total;
                        currentPage = page;
                      });
                    },
                  ))
                ),
              ],
            ),
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.deepPurple,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("Loading".tr()+" ${ (widget.billdata!.bi_category)  } ..."),
                  ),

                ],
                ),

            ),
          )

              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
      floatingActionButton: Stack(
          children: [
//            Container(
//              height: MediaQuery.of(context).size.height,
//              width: MediaQuery.of(context).size.width,
//              margin: EdgeInsets.only(left: 10),
//              padding: EdgeInsets.all(10),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  FutureBuilder<PDFViewController>(
//                    future: _controller.future,
//                    builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//                      if (snapshot.hasData) {
//                        return FloatingActionButton.extended(
//                          label: Text("Go to ${pages! ~/ 2}"),
//                          onPressed: () async {
//                            await snapshot.data!.setPage(pages! ~/ 2);
//                          },
//                        );
//                      }
//
//                      return Container();
//                    },
//                  ),
//
//
//                ],
//              ),
//            ),
            Positioned(
              top: 40,
              left: 25,
              child: Container(
                height: 35,
                width: 90,
                child: SizedBox(
                  width: 45,
                  child: FloatingActionButton.extended(

                    onPressed: (){

                      Navigator.pop(context);


                    },
                    label: Text("Back".tr()),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Icon(Icons.arrow_back_ios,size: 15,),
                    ),
                    backgroundColor: Colors.deepPurple,
                    elevation: 2,

                  ),
                ),
              ),
            ),
            Positioned(
              bottom:  10,
              right: 15,
              child: !isReady  ? Text("Loading pages...".tr() , style: TextStyle(fontSize: 10),) :Text(" ${currentPage!+1}/$_total"),


            )



          ],
      )
    );
  }

  Future<void> initPDF() async {
   await Future.delayed(const Duration(milliseconds: 2000));
    _firstLoad = true;
    setState(() {

    });


  }
}