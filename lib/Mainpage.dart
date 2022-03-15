// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sggs/drawer.dart';
import 'package:sggs/model/global_state.dart';
import 'package:sggs/model/model.dart';
import 'package:sggs/service/dervice.dart';
import 'package:sggs/utils/http_services.dart';
import 'package:sizer/sizer.dart';

class MainPage extends StatefulWidget {
  final String langId;
  MainPage(this.langId);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // fetchGumPage();
    fetchPage();
    fetchContent();
  }

  // ContentModel? data;
  List? contentList;

  var listData;
  fetchContent() async {
    totalPages.clear();
    
    listData = await APIManager().getContent(context, widget.langId);
    var data = ContentModel.fromJson(jsonDecode(listData));

    data.contents!.forEach((item) {
      totalPages.putIfAbsent(item!.pageno!, () => [item]);
      if (totalPages.containsKey(item.pageno!)) {
        totalPages.update(item.pageno!, (value) => value).add(item);
      } else {
        totalPages.putIfAbsent(item.pageno!, () => [item]);
      }
    });

    setState(() {});
    // return listData;
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Favorite',
    'Settings',
    'Account',
  ];
  var currentIndex = 1;

  GlobalKey<ScaffoldState> Scaffoldkey = GlobalKey<ScaffoldState>();
  // @override
  // void initState() {
  //   super.initState();
  //   funtion();
  // }


  Map<String, dynamic> totalPages = {};

  ScrollController _scrollController = new ScrollController();

  ContentModel? pageData;
  ContentModel? pageGumData;

  fetchPage() async {
    var getPage =
        await APIManager().getPageContent(context, widget.langId, currentIndex);

    setState(() {
    pageData = ContentModel.fromJson(jsonDecode(getPage));      
    });
    fetchGumPage();
  }


    fetchGumPage() async {
    var getPage =
        await APIManager().getPageContent(context, '1', currentIndex);
    setState(() {
    pageGumData = ContentModel.fromJson(jsonDecode(getPage));      
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(     
        // floatingActionButton: FloatingActionButton(onPressed: (){
        //   print(widget.langId);
        //   print(pageData!.contents![0]!.line);
        // }),
        resizeToAvoidBottomInset: false,
        key: Scaffoldkey,
        drawer: const Drawerr(),
        body: Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 3.w,
                  right: 3.w,
                  // top: 3.h,
                  bottom: 3.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 60,
                              width: 100,
                              child: Image.asset("Assets/mh.png"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Scaffoldkey.currentState?.openDrawer();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("Assets/menu.png"),
                                      fit: BoxFit.fill)),
                              height: 50,
                              width: 30,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 11, right: 11, top: 13, bottom: 13),
                                  fillColor: Color(0xffF7F8FD),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.8),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0.8, color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      width: 0.8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Search your destination",
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                  // suffixIconColor: Colors.black,
                                  suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.search,
                                        size: 15,
                                      ),
                                      onPressed: () {})),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              // height: MediaQuery.of(context).size.height * 0.20,
                              // width: MediaQuery.of(context).size.width * 0.75,
                              child: Image.asset("Assets/Main.png"),
                            ),
                          ),
                          ((pageData != null) && (pageGumData != null))
                              ?  ListView.separated(
                                  // controller: _scrollController,
                                  shrinkWrap: true,
                                  // reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: pageData!.contents!.length,

                                  separatorBuilder: (BuildContext context, int index){
                                    var content = pageData!.contents![index];
                                     return   Text(
                                          content!.line.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                  },
                                  // totalPages["${currentIndex + 1}"].length,
                                  itemBuilder: (context, index) {
                                    var contentGum;
                                    if(pageGumData != null)
                                    contentGum = pageGumData!.contents![index];
                                     
                                    

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                       
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          contentGum!.line.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                  })
                        : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                    strokeWidth: 2,
                                  ),
                                ),
                              
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                    pageData = null;                                      
                                    pageGumData = null;
                                    });
                                    if (currentIndex < 2) {
                                      currentIndex = 1;
                                    } else {
                                      currentIndex--;
                                      fetchPage();
                                      // fetchGumPage();
                                    }
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                              Text("${currentIndex} / "),
                              Text("${totalPages.length}"),
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      pageData = null;
                                      pageGumData = null;
                                    });
                                    if (currentIndex < totalPages.length) {
                                      currentIndex++;
                                     fetchPage();
                                    //  fetchGumPage();
                                    }
                                    setState(() {
                                      // SchedulerBinding.instance
                                      //     ?.addPostFrameCallback((_) {
                                      //   _scrollController.animateTo(
                                      //       _scrollController
                                      //           .position.maxScrollExtent,
                                      //       duration: const Duration(
                                      //           milliseconds: 400),
                                      //       curve: Curves.fastOutSlowIn);
                                      // });
                                    });
                                  },
                                  icon: Icon(Icons.arrow_forward_ios)),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("Assets/Main1.png"),
                                    fit: BoxFit.fill)),
                            height: 25.w,
                            width: 100.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.0.w, right: 8.0.w, top: 3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.0, right: 12.0),
                                  child: Text(
                                    "There is only one God whose Name О is of Eternal Existence'.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 37.w,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                // Text(
                                //   "Contemplate and reflect upon knowledge, and you shall become a benefactor to others. When you conquer the five vices fest anger read attachment. 2007 then you shall become avoos ake a diveller at The Sacred shrir af penzuge 3CC5online.com humbl attemptis re eamestilij contempihet siect weer rd hasure Na suide standapuu Enish language.Contemplate and reflect upon knowledge, and you shall become a benefactor to others. When you conquer the five vices fest anger read attachment. 2007 then you shall become avoos ake a diveller at The Sacred shrir af penzuge 3CC5online.com humbl attemptis re eamestilij contempihet siect weer rd hasure Na suide standapuu Enish language.",
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 12.sp,
                                //     fontWeight: FontWeight.w400,
                                //     // letterSpacing: 0.3,
                                //     fontStyle: FontStyle.italic,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: buildMyNavBar(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int pageIndex = 0;
//
  Container buildMyNavBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 25,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 25,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                    size: 20,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.bookmark,
                    color: Colors.black,
                    size: 25,
                  )
                : const Icon(
                    Icons.bookmark_outline,
                    color: Colors.black,
                    size: 20,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? const Icon(
                    Icons.favorite,
                    color: Colors.black,
                    size: 25,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                    size: 20,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 4;
              });
            },
            icon: pageIndex == 4
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.white)),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: const Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// class Content extends StatelessWidget {
//   const Content({Key? key, this.size}) : super(key: key);
//   final Size? size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       width: size!.width,
//       // height: 200,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.8),
//               spreadRadius: -6,
//               blurRadius: 10,
//               offset: Offset(1, 0),
//               // blurStyle: BlurStyle.solid,
//             ),
//           ]),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: const [
//           Text(
//             "'ਰੱਬ ਦੀ ਸਿਫ਼ਤਿ ਸਾਲਾਹ ਸੁਣਨ ਕਰਕੇ (ਮਨੁੱਖ ਦੇ) ਦੁਖਾਂ ਤੇ ਪਾਪਾਂ ਦਾ ਨਾਸ਼ ਹੋ ਜਾਂਦਾ ਹੈ'",
//             style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 25,
//                 // decoration: TextDecoration.underline,
//                 // decorationStyle: TextDecorationStyle.dashed,
//                 fontWeight: FontWeight.w900,
//                 shadows: [
//                   Shadow(
//                       color: Colors.black,
//                       offset: Offset(2.0, 1.0),
//                       blurRadius: 2.0),
//                 ]),
//           ),
//           // SizedBox(height: 10,),
//           Text(
//             "(11547, 1, 'suni-ai sat santokh gi-aan.', 2, 1, 'pp')",
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 shadows: [
//                   Shadow(
//                       color: Colors.black,
//                       offset: Offset(2.0, 1),
//                       blurRadius: 1.5),
//                 ]),
//           ),

//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             thickness: 2,
//             endIndent: 40,
//           ),
//           Text(
//             "By listening to Naam, one acquires truthfulness, contentment and spiritual knowledge', 2, 1, 'et'",
//             style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 0.2,
//                 shadows: [
//                   //  Shadow(
//                   //     color: Colors.black,
//                   //     offset: Offset(2.0, 1),
//                   //     blurRadius: 2.0),
//                 ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
