import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/subpages/bill_detail.dart';
import 'package:flutter_app/pages/widgets/dates_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:date_range_form_field/date_range_form_field.dart';

import 'package:flutter_app/model/billing_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';
import 'package:awesome_calendar/awesome_calendar.dart'; 

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

//List<Color> iconButtonColors = new List<Color>();



class _BillingPageState extends State<BillingPage> {

  @override
  void initState() {
    // TODO: implement initState

//    _dropdownTestItems = buildDropdownTestItems(_testList);

    super.initState();


  }



//  onChangeDropdownTests(selectedTest) {
//    print(selectedTest);
//    setState(() {
//      _selectedTest = selectedTest;
//    });
//  }

  @override
  Widget build(BuildContext context) {

    return billPageScf();

  }


  Widget _buildBox(){

   return SizedBox(
   child: Container(margin: EdgeInsets.all(12), height: 100, width: 200, color: Colors.redAccent),
   );

  }


  Widget searchBar(){
      return Container();
//    return Container(
//      color: Colors.white,
//      padding: const EdgeInsets.all(8.0),
//      child: TextField(
//        onChanged: (valuex) {
//          print(valuex);
//        //  filterSearchResults(valuex);
//        },
//        controller: editingController,
//        decoration: InputDecoration(
//            labelText: "Search",
//            hintText: "Search",
//            prefixIcon: Icon(Icons.search),
//            border: OutlineInputBorder(
//                borderRadius: BorderRadius.all(Radius.circular(5.0)))),
//      ),
//    );

  }

  Widget cupdatpicker(){
    return   Container(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime(1969, 1, 1),
        onDateTimeChanged: (DateTime newDateTime) {
          print(newDateTime);
        },
      ),
    );
  }


//  Widget fileterBox = Container(
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.start,
//      children:<Widget>[
//      Text("${selectedDate.toLocal()}".split(' ')[0]),
//      SizedBox(height: 20.0,),
//      RaisedButton(
//      onPressed: () => _selectDate(context),
//      child: Text('Select date'),
//      ),
//    ),
//
//  );

 Widget rangeDatePick (){

    return Container();

//
//    return Container(
//      padding: EdgeInsets.only(top: 15),
//      child: Row(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          RaisedButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(5.0)
//            ),
//            elevation: 4.0,
//            onPressed: (){
//              DatePicker.showDatePicker(context,
//              theme: DatePickerTheme(
//                containerHeight: 210.0,
//              ),
//
//                showTitleActions: true,
//                minTime: DateTime(2020,1,1),
//                maxTime: DateTime(2022,12,31),
//                onConfirm: (date){
//                  print('confirm $date');
//                  setState(() {
//                    _date = '${date.year} - ${date.month} - ${date.day}';
//                  });
//                },
//                currentTime: DateTime.now() , locale: LocaleType.zh
//              );
//
//            },
//            child: Container(
//               alignment: Alignment.center,
//               height: 50.0,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Container(
//                    child: Row(
//                      children: [
//                        Icon(Icons.date_range,size: 18.0,color: Colors.teal,),
//                        new Padding(
//                          padding: EdgeInsets.only(left: 5.0),
//                          child: Text(" ${_date}" , style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 18,),),
//                        ),
//
//                      ],
//                    ),
//                  ),
//
//                ],
//              ),
//            ),
//            color: Colors.white,
//          ),
//
//
//          SizedBox(
//            width: 40.0,
//            child: Container(
//              child: Padding(
//                padding : EdgeInsets.fromLTRB(10, 0, 10, 0),
//                child: Text(" To " , style: TextStyle(fontWeight: FontWeight.bold),),
//              ),
//            ),
//          ),
//
//
//          RaisedButton(
//            child: Container(
//              alignment: Alignment.center,
//              height: 50.0,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Container(
//                      child: Row(
//                        children: [
//                          Icon(Icons.date_range,size: 18.0,color: Colors.teal,),
//                          new Padding(
//                            padding: EdgeInsets.only(left: 5.0),
//                            child: Text(" ${_date}" , style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 18,),),
//                          ),
//
//                        ],
//                      ),
//                    ),
//                  ]
//              ),
//            ),
//
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(5.0)
//            ),
//            onPressed: (){
//
//            },
//            elevation: 4.0,
//            color: Colors.white,
//          ),
//
//
//        ],
//      ),
//    );
 }


}

class myBehavior extends ScrollBehavior{

  @override
  Widget buildViewportChrome (BuildContext context , Widget child , AxisDirection axisDirection ){
    return child;
  }


}

class amountPaint extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint();
    canvas.drawLine(
        Offset(size.width * 1 /6 , size.height * 1.5 ),
        Offset(size.width * 5 /6 , size.height *0),
        paint
    );


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;



}


class OpenPainter extends CustomPainter {

  Color inputcolor;

  OpenPainter( this.inputcolor);

  @override
  void paint(Canvas canvas, Size size , { TextDirection ?textDirection }) {

    var paint1 = Paint()
      ..color =  inputcolor
      ..style = PaintingStyle.fill;
    //a rectangle

     canvas.drawRect(Offset(0, 0) & Size(90, 25), paint1);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}




class billPageScf extends StatefulWidget {
  @override
  _billPageScfState createState() => _billPageScfState();
}

class _billPageScfState extends State<billPageScf> {


  void initState(){

    super.initState();

    getCred();
//    dateEnd = DateTime(dateStart.year, dateStart.month + 1, 0);
    dateEnd = dateLimit;
    DateDisplay = "${DateFormat('yyyy-MM-01').format(dateStart)} TO ${DateFormat('yyyy-MM-dd').format(dateEnd)}";

    post_dateStart = DateFormat('yyyy-MM-01').format(dateStart);
    post_dateEnd = DateFormat('yyyy-MM-dd').format(dateEnd);

    setState(() {

    });

  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    editingController.dispose();
    super.dispose();
  }


  DateTimeRange? myDateRange;

  GlobalKey<FormState> myFormKey = new GlobalKey();



  void getCred() async{

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userId = pref.getString("user_id")!;
      _future =   getBillingJson(pages);

    });

  }



  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }


  final editingController = TextEditingController();
  String _date = "Not set";


//
  Future<List<billingData>> getBillingJson(pages) async{

    print("userid  > $userId");
    print("post_searchkey  > $post_searchkey");
//  List<billingData> items = [];
    Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/billing_json.php");
    var data_post = {
      "accountID" :  userId ,
      "types" :  _SelectBillType,
      "page" : pages.toString(),
      "perlimit" : perlimit.toString(),
      "dateStart" : post_dateStart,
      "dateEnd" : post_dateEnd,
      "searchBill" : post_searchkey,
    };

    print("$post_dateStart -> $post_dateEnd");


    var data = await http.post(url,body:data_post);

    if(data.statusCode == 200){

//    xdatabody = json.encode(xdatabody);

      if(data.body == "no_data" ) {
//        print(" data.body " + data.body);
//        print("$userId");
//        print("${pages.toString()}");

        print("isend");

        _refreshController.loadNoData();

      }else {

        var JsonData = json.decode(data.body);

        for (var ma in JsonData) {
          //items.add(billingData.fromJson(JsonData));
          try {
//            billingData m = billingData(
//                ma["bi_id"], ma["bi_category"], ma["bi_totalamount"]);
//            print(ma);
            billingData m = billingData.fromJson(ma);
            _items.add(m);

          } catch (e) {
            print(e.toString() + " < is json");
          }
//        items.add( billingData.fromJson(ma) );
        }

      }

      await Future.delayed(Duration(milliseconds: 1000));
      print( " _items.length >  ${_items.length}");
      return _items;

    }else{

      _refreshController.loadFailed();
      return _items;
    }

  }


//  List<String> items =  ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch

    // if failed,use refreshFailed()
//    _items.add((_items));

    setState(() {
      pages = 0;
      _items.clear();
      _future = getBillingJson(pages);
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();


  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length).toString());



    if(mounted){

      setState(() {
        pages = pages + perlimit;
      });

      getBillingJson(pages);
      _refreshController.loadComplete();


    }

  }


//  Future<List<billingData>> _loadData() async {
//
//    await Future.delayed(Duration(milliseconds: 1000));
//
////    _items = [];
////    for (int i = 0; i < 20; i++) {
////      items.add((Random().nextInt(10)+1).toString());
////    }
//    return getJson(pages);
//
//  }


  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }



  void _submitForm() {
    final FormState form = myFormKey.currentState!;
    form.save();
  }

  Future ?_future;
  String userId ="" ;
  int pages = 0 ;
  int perlimit = 5;

  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();
  DateTime dateLimit =  DateTime.now();

  String ?post_dateStart;
  String ?post_dateEnd;
  String post_searchkey = "";
  String post_billtype = "invoice";


//  List _testList  =  [{'no': 1, 'keyword': 'Invoice'},{'no': 2, 'keyword': 'Quotaion'},{'no': 3, 'keyword': 'Order'}];
//  List<DropdownMenuItem> _dropdownTestItems;
//  String _selectedTest = "Invoice";
  List<billingData> _items = <billingData>[];

  String _SelectBillType = "invoice";

  List<String> menuItems = ["invoice","quotation","receipt","delivery","order"];


  List<DateTime> ?rangeSelect;
  String ?DateDisplay;

  Future<void> rangeSelectPicker() async {

    final List<DateTime>? picked = await showDialog<List<DateTime>>(
      context: context,
      builder: (BuildContext context) {
        return const AwesomeCalendarDialog(
          selectionMode: SelectionMode.range,
        );
      },
    );

    if (picked != null) {
//      print(DateFormat('yyyy-MM-dd').format(picked[0]));
//      print(DateFormat('yyyy-MM-dd').format(picked[1]));

      DateTime d0 = picked[0];
      DateTime d1 = picked[1];


      if(d0.isAfter(d1)){
        print("$d0 > $d1");
        d0 = picked[1];
        d1 = picked[0];
      }

      if(d0.isAfter(dateLimit)){
        d0 = dateLimit;
      }

      if(d1.isAfter(dateLimit)){
        d1 = dateLimit;
      }

      setState(() {
        _items.clear();
        DateDisplay = "${DateFormat('yyyy-MM-dd').format(d0)} TO ${DateFormat('yyyy-MM-dd').format(d1)} ";
        post_dateStart = DateFormat('yyyy-MM-dd').format(d0);
        post_dateEnd = DateFormat('yyyy-MM-dd').format(d1);

        rangeSelect = picked;
        pages = 0;
        _future =   getBillingJson(pages);
      });


      print(" pages = > $pages");


    }



  }


  Timer ?searchTime;
  String ?_temp_searchvalue;

  Color _iconColor = Colors.black;

  Widget openDateWidget(){

    return DateRangeField(
        firstDate: DateTime(1990),
        enabled: true,
        dateFormat: DateFormat("yyyy/MM/dd") ,
        initialValue: DateTimeRange(
          start: dateStart,
          end: dateEnd,

        ),
        decoration:InputDecoration(
          alignLabelWithHint: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),

        ),
        validator: (value) {
          if (value!.start.isBefore(DateTime.now())) {
            return 'Please enter a later start date';
          }
          return null;
        },
        onChanged: (value){

          DateTime _valueStart = value!.start;
          DateTime _valueEnd = value.end;



          if(_valueStart.isAfter(dateLimit)){
            _valueStart = dateLimit;
          }

          if(_valueEnd.isAfter(dateLimit)){
            _valueEnd = dateLimit;
          }


          setState(() {
            dateEnd = _valueEnd;
            dateStart = _valueStart;

            print(dateEnd);

          });


        },
        onSaved: (value) {
          setState(() {
            myDateRange = value;
          });

        });



  }



  Widget imageBox = Container(
    child: Image.asset("assets/images/myposlogo4_663259.jpg",fit: BoxFit.cover,),
  );

  Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    color: Colors.redAccent,
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                color: Colors.green,
                child: const Text(
                  'Oeschinen Lake Campground',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Kandersteg, Switzerland',
                style: TextStyle(
                  color: Colors.grey[500],
                  backgroundColor: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
        /*3*/
        Icon(
          Icons.star,
          color: Colors.red[500],
        ),
        const Text('41'),
      ],
    ),
  );


  void filterSearchResults(String query) {

    setState(() {
      post_searchkey = query;

      print("query > " +query);
      pages = 0;
      _items.clear();
      _future = getBillingJson(pages);

    });

  }


  Widget myBillCard(BuildContext context, int index) {



    return  Stack(

      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: ()=>{

            Navigator.push(context,CupertinoPageRoute(builder: (context) => bill_detail(headtitle: " ${_items[index].gbl_type!.toUpperCase()} #${_items[index].bi_id!.padLeft(5, '0')}" , selectedItems_: _items[index], key: UniqueKey(), )))


//            showDialog(context: context, builder: (context){
//                 return Dialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))
//                   ),
//                   child: Container(
//                     height: 450, child: Column(
//                     children: [
//                       Text(" ${_items[index].gbl_id} "),
//                       Text("bababababba")
//                     ],
//                   ),
//                   ),
//                 );
//               })


          },
          child: Card(

//            semanticContainer: true,
            elevation: 0,
            color: Colors.transparent,
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(

//              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),

            ),
            //                                  child: Center(
            //                                    child: Text(" text : ${ items[index].toString()} / ${index}" ),
            //                                  ),
            child: Container(

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [
                      0.90,
                      0.90,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white,
                      (_items[index].bi_payment_status == "paid" ? Colors.green:Colors.red),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!.withOpacity(0.15),
                      offset: Offset(0, 1),
                      spreadRadius: 0.5,
                      blurRadius: 0.7,

                    )
                  ]),

              height: 150,
              width: MediaQuery.of(context).size.width-35,
              child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 0,
                      child: Container(
                        width: widthBillTypeConvertor(_items[index].bi_category!),
                        height: 25,
                        decoration: BoxDecoration(
                          color: (_items[index].bi_payment_status == "paid"? Colors.green : Colors.red),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15)),
                        ),

                      ),
//                      child: CustomPaint(
//                        painter: OpenPainter(_items[index].bi_payment_status == "paid"? Colors.green : Colors.red),
//                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 125,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20,right: 22,top: 20),
                            child:  Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 120,

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            child: Row(
                                              children: [
                                                Text(
                                                  (_items[index].bi_category == null ? "" : "${_items[index].bi_category!.toUpperCase()}"),
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white),),
                                                SizedBox(width: 20,),
                                                Text(
                                                  (_items[index].bi_category == null ? "" : "#${_items[index].bi_id!.padLeft(5,"0")}"),
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                              ],
                                            )
                                        ),
                                        SizedBox(height: 12,),
                                        Text("${_items[index].bi_termname}" , style: TextStyle(color: Colors.grey),),
                                        SizedBox(height: 8,),
                                        isShowAmount(_items[index].bi_category!) == true?
                                        Container(
                                          padding: EdgeInsets.only(right: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Text("${double.parse(_items[index].totalPaidAmount!).toStringAsFixed(2)}" ,
                                                    style: TextStyle(color: Colors.grey[600],fontSize: 28,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                              new CustomPaint(
                                                size: new Size(20, 20),
                                                painter: amountPaint(),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("Amount" , style: TextStyle(color: Colors.grey,fontSize: 10),),
                                                  Text("${(_items[index].bi_termtype == "loan" ? "${ double.parse(_items[index].bi_termamount!).toStringAsFixed(2)   }":"${ double.parse(_items[index].bi_totalamount!).toStringAsFixed(2)  }" )}" ,
                                                      style: TextStyle(color: Colors.grey[600],fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1),

                                                ],
                                              ),


                                            ],

                                          ),
                                        ) :
                                        Container(
                                          padding: EdgeInsets.only(right: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("${(_items[index].bi_termtype == "loan" ? "${   double.parse(_items[index].bi_termamount!).toStringAsFixed(2)  }":"${ double.parse(_items[index].bi_totalamount!).toStringAsFixed(2)  }" )}" ,
                                                    style: TextStyle(color: Colors.grey[600],fontSize: 28,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                              new CustomPaint(
                                                size: new Size(20, 20),
                                                painter: amountPaint(),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("Amount" , style: TextStyle(color: Colors.grey,fontSize: 10),),
                                                  Text("${(_items[index].bi_termtype == "loan" ? "${ double.parse(_items[index].bi_termamount!).toStringAsFixed(2)   }":"${ double.parse(_items[index].bi_totalamount!).toStringAsFixed(2)  }" )}" ,
                                                      style: TextStyle(color: Colors.grey[600],fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1),

                                                ],
                                              ),


                                            ],

                                          ),

                                        ),


//                                    IntrinsicHeight(
//                                      child: Container(
//                                        padding: EdgeInsets.only(right: 25),
//                                        child: Row(
//                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                          children: [
//                                            Column(
//                                              crossAxisAlignment: CrossAxisAlignment.start,
//                                              children: [
//                                                Text("Amount (RM):  " , style: TextStyle(color: Colors.grey,fontSize: 10),),
//                                                Text("${(_items[index].bi_termtype == "loan" ? "${   double.parse(_items[index].bi_termamount).toStringAsFixed(2)  }":"${ double.parse(_items[index].bi_totalamount).toStringAsFixed(2)  }" )}" ,
//                                                  style: TextStyle(color: Colors.grey[600],fontSize: 28,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
//                                              ],
//                                            ),
//                                            VerticalDivider(
//                                              color: Colors.grey[400],
//                                              width: 40,
//                                              indent: 5,
//                                              endIndent: 5,
//                                              thickness: 0.4,
//                                            ),
//                                            Column(
//                                              crossAxisAlignment: CrossAxisAlignment.start,
//                                              children: [
//                                                Text("Received (RM):  " , style: TextStyle(color: Colors.grey,fontSize: 10),),
//                                            Text("${(_items[index].bi_termtype == "loan" ? "${ double.parse(_items[index].bi_termamount).toStringAsFixed(2)   }":"${ double.parse(_items[index].bi_totalamount).toStringAsFixed(2)  }" )}" ,
//                                              style: TextStyle(color: Colors.grey[600],fontSize: 28,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1),
//
//                                              ],
//                                            ),
//
//
//                                          ],
//
//                                        ),
//                                      ),
//                                    ),




                                      ],
                                    ),



                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  ]

              ),

            ),

          ),
        ),

        isShowAmount(_items[index].bi_category!) == true ? Positioned(
          top: 48,
          right: 64.5,
          child: Opacity(
              opacity: 0.5,
              child: Text("${_items[index].bi_payment_status}".toUpperCase() ,
                  style: TextStyle(fontWeight: FontWeight.bold,color: (_items[index].bi_payment_status == "paid" ? Colors.green[800] : Colors.red[800]) , fontSize: 15 , ))
          ),
        ) : Container(),


        Positioned(
          top: 27,
          right: 25,
          child: (_items[index].bi_payment_status == "paid" ? Icon(Icons.check_circle,color: Colors.white,) :Icon(Icons.payment,color: Colors.white,)),
        ),



        Positioned(
          top: 30,
          right: 64.5,
          child: Container(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:   [
                Row(
                  children: [
                    Text("${ convertDateDip(_items[index].bi_startdate!).toString().toUpperCase() }" , style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54,fontSize: 15),),
                  ],
                ),
              ],
            ),
          ),
        ),




//        Positioned(
//          bottom:  20 ,
//          right: 20,
//          child: Container(
//            child: Text("My Data"),
//          ),
//        ),




//        Positioned(
//          bottom:  30 ,
//          right: 20,
//          child: new IconButton(
//            icon: const Icon(Icons.payment),
//            color: _iconColor,
//            onPressed: () {
//
//               setState(() {
//                 _iconColor = Colors.blueAccent;
//               });
//
//               showDialog(context: context, builder: (context){
//                 return Dialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))
//                   ),
//                   child: Container(
//                     height: 450, child: Column(
//                     children: [
//                       Text("ABABABABBA"),
//                       Text("bababababba")
//                     ],
//                   ),
//                   ),
//                 );
//               });
//
//
//              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Enter ${_items[index].billId}."),backgroundColor: Colors.blueAccent,));
//
//            },
//            padding: EdgeInsets.all(5),
//          ),
//        )
      ],
    );

  }












  convertDateDip(String bi_startdate) {

    return DateFormat('MMM dd, yyyy').format(DateTime.parse(bi_startdate));

  }

  double widthBillTypeConvertor(String bi_termtype) {


    switch(bi_termtype){
      case "invoice" : return 90.0; break;
      case "quotation" : return 115.0; break;
      default : return 90;
    }

  }

  bool isShowAmount(String bi_termtype) {

    switch(bi_termtype){
      case "invoice" : return true; break;
      default : return false;
    }

  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: null,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll){
          overScroll.disallowIndicator();
          return true;

        },
        child:  SafeArea(
          child: Container(
//            color: Colors.blueAccent,
            child: Column(
              children: [
////                imageBox,
//                searchBar(),
//                rangeDatePick(),
//              new  Container(
//                height: MediaQuery.of(context).size.height,
//                child: SmartRefresher(
//                  enablePullDown: true,
//                  enablePullUp: true,
//                  header: WaterDropHeader(),
//                  footer:   ClassicFooter(
//                    loadStyle: LoadStyle.ShowWhenLoading,
//                    completeDuration: Duration(milliseconds: 500),
//                  ),
//                  controller: _refreshController,
//                  onRefresh: _onRefresh,
//                  onLoading: _onLoading,
//                  child: SizedBox(
//                    child: ListView.builder(
//                      itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
//                      itemExtent: 100.0,
//                      itemCount: (items.length),
//                    ),
//                  ),
//
//                ),
//              ),
                new Container(
                    height: 126,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow:[   BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 1.5), // changes position of shadow
                        ),]

                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: TextField(
                            onChanged: (value) async {

                              _temp_searchvalue = value;

                              if(searchTime == null){

                                searchTime = new Timer(Duration(seconds: 1), () {
                                  filterSearchResults(_temp_searchvalue!);
                                  searchTime?.cancel();
                                });

                              }else{

                                searchTime?.cancel();
                                searchTime = new Timer(Duration(seconds: 1), (){
                                  filterSearchResults(_temp_searchvalue!);
                                  searchTime?.cancel();
                                });



                              }


//                              await Future.delayed(Duration(milliseconds: 3000)).then(
//                                  (v){
//                                    filterSearchResults(_temp_searchvalue);
//                                  }
//                              );

                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: EdgeInsets.all(0),
                                hintText: "Search Bills".tr(),
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(18, 0, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,

                          ),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
//                            Text("Date Select"),
//                            SizedBox(height: 5,),
                              Container(
                                alignment: Alignment.center,
                                height:25,
                                margin: EdgeInsets.only(top: 10,left: 5),

                                child: TextButton(
                                  child: Text(DateDisplay!, style: TextStyle(color: Colors.white, fontSize: 12),),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[400]?.withOpacity(0.6),
                                      padding: EdgeInsets.all(6)

                                  ),
                                  onPressed: (){
                                    rangeSelectPicker().then((v)=>{
                                    });
                                  },

                                ),
                              ),
                              Container(

                                margin: EdgeInsets.only(top: 10,right: 10),
                                alignment: Alignment.bottomRight,
                                height: 28,
                                width: 85,
                                decoration: BoxDecoration(

                                ),
                                child:  DropdownButton<String>(
//                                isExpanded: true,
                                  alignment: Alignment.bottomRight,
                                  icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
                                  underline: SizedBox(),
                                  hint: Text(post_billtype, style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                  value : _SelectBillType,
                                  onChanged: (value){
                                    setState(() {
                                      _SelectBillType = value!;
                                      _items.clear();
                                      pages = 0;
                                      _refreshController.resetNoData();
                                      _future = getBillingJson(0);
                                      print("Select $value");

                                    });
                                  },
                                  items: menuItems.map((String Val){
                                    return DropdownMenuItem<String>(
                                      value: Val,
                                      child: Text(Val.toUpperCase(), style: TextStyle(color: Colors.grey[500],fontSize: 14),),
                                    );
                                  }).toList(),
                                  elevation: 50,
                                ),
                              ),

//                            TextButton(
//                              child: Text("INVOICE", style: TextStyle(color: Colors.grey[500]),),
//                              onPressed: (){
//                                print("hallo");
//                              },
//                            ),

//                            DropdownBelow(
//                              itemWidth: 200,
//                              itemTextstyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
//                              boxTextstyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFFbbbbbb)),
//                              boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
//                              boxHeight: 45,
//                              boxWidth: 200,
//                              hint: Text('choose item'),
//                              value: _selectedTest,
//                              items: _dropdownTestItems,
//                              onChanged: onChangeDropdownTests,
//                            ),

                            ],


                          ),

                        ),

                      ],
                    )

                ),
                new Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SizedBox(
                        child:
                        SafeArea(
                            child: Container(
                              color: Colors.grey.withOpacity(0.0),
                              child:   FutureBuilder(
                                  future:  _future,
                                  builder: (context,snapshot){

                                    if(snapshot.connectionState == ConnectionState.done){

                                      if(snapshot.hasError){

                                        return Center( child: Text('${snapshot.error} > error'),);

                                      }else if(snapshot.hasData) {


//                                    print(snapshot.data[0].billId);
                                        if(_items.length > 0) {

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
                                                  body = Text("Failed");
                                                }else if ( mode == LoadStatus.canLoading){
                                                  body = Text("loading");
                                                }else{
                                                  body = Text("no more data");
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
                                                return myBillCard(context , index);
                                              },
                                              shrinkWrap:false,
                                              itemExtent: 145,
                                              itemCount:_items.length,
                                            ),

                                          );


                                        }else{

                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: SizedBox(
                                                height: 200,
                                                width: 400,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                          padding: const EdgeInsets.all(0),
                                                          child: Image(image: AssetImage("assets/images/no_record.png"),width: 150,height: 150,)
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 15),
                                                        child: Text("No Record Found", style: TextStyle(color: Colors.grey[600],fontSize: 12,letterSpacing: 1),),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );


                                        }

                                      }else{

                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircularProgressIndicator(),
                                                    Padding(
                                                      padding: const EdgeInsets.all(25.0),
                                                      child: Text("Someting Wrong...", style: TextStyle(color: Colors.grey[700],fontSize: 12,letterSpacing: 1),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );



                                      }

                                    }else{

                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            height: 150,
                                            width: 150,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Padding(
                                                    padding: const EdgeInsets.all(25.0),
                                                    child: Text("Loading...", style: TextStyle(color: Colors.grey[700],fontSize: 12,letterSpacing: 1),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );

                                    }


                                  }
                              ),
                            )
                        )
                    ),
                  ),


                )




//                new Container(
//                  child: Column(
//                    children: [
//                      new Row(
//                       children: [
//                         SafeArea(
//                           child: Form(
//                             key: myFormKey,
//                             child: Column(
//                               children: [
//                                  SafeArea(
//                                    child: SizedBox(
//                                      width: MediaQuery.of(context).size.width,
//                                      child: DateRangeField(
//                                          firstDate: DateTime(1990),
//                                          enabled: true,
//                                          dateFormat: DateFormat("yyyy/MM/dd") ,
//                                          initialValue: DateTimeRange(
//                                              //start: DateTime.now(),
////                                              start: DateTime.parse('2020-01-02'),
//                                              start: dateStart,
//                                              end: dateEnd,
////                                              end: DateTime.now().add(Duration(days: 5))
//
//                                          ),
//
//                                          decoration: InputDecoration(
//                                            labelText: 'Billing Range',
//                                            prefixIcon: Icon(Icons.date_range),
//                                            hintText: 'Please select a start and end date',
//                                            border: OutlineInputBorder(),
//                                          ),
//                                          validator: (value) {
//                                            if (value.start.isBefore(DateTime.now())) {
//                                              return 'Please enter a later start date';
//                                            }
//                                            return null;
//                                          },
//                                          onChanged: (value){
//
//                                            print( DateFormat('yyyy-MM-dd').format(value.start) );
//                                            print( DateFormat('yyyy-MM-dd').format(value.end)  );
//
//                                            setState(() {
//
//                                              dateEnd = value.end;
//                                              dateStart = value.start;
//
//                                            });
//
//
//                                          },
//                                          onSaved: (value) {
//
//                                            print(value);
//
//                                            setState(() {
//                                              myDateRange = value;
//
//                                            });
//
//                                          }),
//                                    )
//                                  ),
//
//                               ],
//                             ),
//                           ),
//                         )
//
//                       ],
//
////                        children: [
////                          IconButton(
////                            icon: Icon(Icons.date_range),
////                            onPressed: () async {
////
////
////                            },
////
//////                            onPressed: (){
//////                              print("IsPressed");
//////
//////                              Navigator.push(
//////                              context, MaterialPageRoute(builder: (_) => WidgetPage()));
//////
//////                            },
////                          ),
////
////                        ],
//
//                      )
//                    ],
//                  ),
//                ),



//                new SafeArea(
//                  child: Container(
//
//                    child:  new FutureBuilder(
//
////                      future: _loadData(),
//                      future: _future,
//                      builder: (context,snapshot){
//
//                        if(snapshot.hasError){
//
//                          return Center( child: Text('${snapshot.error}'),);
//
//                        }else if(snapshot.hasData){
//
//                          return SmartRefresher(
//                            enablePullDown: true,
//                            enablePullUp: true,
//                            header: WaterDropHeader(),
//                            footer: CustomFooter(
//                              builder: (context,mode){
//                                Widget body;
//                                if(mode == LoadStatus.idle){
//                                  body = Text("Pull up to load");
//                                }else if ( mode == LoadStatus.loading){
//                                  body = CupertinoActivityIndicator();
//                                }else if ( mode == LoadStatus.failed){
//                                  body = Text("Failed");
//                                }else if ( mode == LoadStatus.canLoading){
//                                  body = Text("loading");
//                                }else{
//                                  body = Text("no more data");
//                                }
//                                return Container(
//                                  height: 55.0,
//                                  child: Center(child: body,),
//                                );
//
//                              },
//                            ),
//                            controller: _refreshController,
//                            onRefresh: _onRefresh,
//                            onLoading: _onLoading,
//                            child: ListView.builder(
//
//                              shrinkWrap: false,
//                              itemBuilder: (context,index){
//                                return Stack(
//
//                                  children: <Widget>[
//                                      Card(
//
//                                        elevation: 5.0,
//                                        margin: EdgeInsets.all(10.0),
//                                      color: Colors.red,
//
//                                      shape: RoundedRectangleBorder(
//                                        borderRadius: BorderRadius.circular(15.0),
//                                        side: BorderSide(
//                                          color: Colors.grey.withOpacity(0.2),
//                                          width: 1,
//                                        ),
//                                      ),
//    //                                  child: Center(
//    //                                    child: Text(" text : ${ items[index].toString()} / ${index}" ),
//    //                                  ),
//                                      child: Container(
//                                        width: MediaQuery.of(context).size.width,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//
//                                         children: [
//                                           SizedBox(
//                                             height: 80,
//                                             width: MediaQuery.of(context).size.width,
//                                             child: Padding(
//                                               padding: EdgeInsets.all(20),
//                                               child:  Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("${_items[index].billId}" , style: TextStyle(),),
//                                                   Expanded(child: Text("${_items[index].billtype} ")),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//
//
//                                         ],
//                                       ),
//
//
//                                      ),
//
//                                    ),
//
//                                    Positioned(
//                                      bottom:  20 ,
//                                      right: 20,
//                                      child: Container(
//                                        child: Text("My Data"),
//                                      ),
//                                    ),
//                                  Positioned(
//                                    bottom:  30 ,
//                                    right: 20,
//                                    child: new IconButton(
//
//
//                                      icon: const Icon(Icons.payment),
//                                      tooltip: 'Increase volume by 10',
//                                      onPressed: () {
//
//                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Enter ${_items[index].billId}."),backgroundColor: Colors.blueAccent,));
//
//                                      },
//                                      padding: EdgeInsets.all(5),
//                                  ),
//                                  )
//
//
//
//                                  ],
//                                );
//                              },
//                              itemExtent: 100.0,
//                              itemCount:_items.length,
//                            ),
//
//                          );
//
//                        }else{
//
//                          return Center(
//                            child: CircularProgressIndicator(),
//                          );
//
//
//                        }
//
//                      },
//                    ),
//                  ),
//
//                )

//
//                new Container(
//                  child: Column(
//                    children: [
//                    FutureBuilder(
//                      future: getJson(),
//                      builder: (BuildContext context,AsyncSnapshot sapshot ){
//                        if(sapshot.data == null){
//
//                          return Center(
//                            child: CircularProgressIndicator(),
//                          );
//
////                          return Container(
////                            child: Center(
////                              child: Padding(
////                                padding: EdgeInsets.all(50),
////                                child: Text("Loading..."),
////                              ),
////                            ),
////                          );
//
//
//
//                        }else{
//
//
////                          return SmartRefresher(
////                            enablePullDown: true,
////                            enablePullUp: true,
////                            header: WaterDropHeader(),
////                            controller: _refreshController,
////                            onRefresh: _onRefresh,
////                            onLoading: getJson,
////                            child: ListView.builder(
////                                itemCount: sapshot.data.length,
////                                itemBuilder: (BuildContext context , int index){
////                                  return ListTile(
////                                    title: Text(sapshot.data[index].billtype),
////                                    subtitle: Text("BillId : " + sapshot.data[index].billId),
////                                  );
////                                }
////                          ),
////
////                          );
//
//                          return SizedBox(
//                            height: 500,
//                            child: ListView.builder(
//                                itemCount: sapshot.data.length,
//                                itemBuilder: (BuildContext context , int index){
//                                  return ListTile(
//                                    title: Text(sapshot.data[index].billtype),
//                                    subtitle: Text("BillId : " + sapshot.data[index].billId),
//                                  );
//                                }
//                            ),
//                          );
//
//                        }
//                      },
//
//                    )
//                    ],
//                  ),
//                ),


              ],
            ),

          ),
        ),
      ),

    );
  }
}

