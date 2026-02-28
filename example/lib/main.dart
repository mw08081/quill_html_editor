import 'dart:convert';

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.grey.shade100;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle =
      const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  bool _hasFocus = false;

  @override
  void initState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });

    html.window.onMessage.listen((html.MessageEvent event) {
      final data = event.data; // String 또는 dynamic

      if (data['action'] == 'GetEmbeddedImageHeight') {
        final value = data['value'];
        final intValue = (value is int) ? value : int.parse(value.toString());
        if (mounted) {
          print('GetEmbeddedImageHeight: $intValue');
        }
      }
    });

    // html.window.onMessage.listen((event) {
    //   if (event.data == 'GetEmbeddedImageHeight') {
    //     if (mounted) {
    //       print('GetEmbeddedImageHeight: ${event.data['value'].toString()}');
    //     }
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double minHeight = 500;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: Column(
            children: [
              ToolBar(
                toolBarConfig: const [
                  ToolBarStyle.size,
                  ToolBarStyle.separator,
                  ToolBarStyle.bold,
                  ToolBarStyle.italic,
                  ToolBarStyle.underline,
                  ToolBarStyle.strike,
                  ToolBarStyle.separator,
                  ToolBarStyle.color,
                  ToolBarStyle.background,
                  ToolBarStyle.separator,
                  ToolBarStyle.alignLeft,
                  ToolBarStyle.alignCenter,
                  ToolBarStyle.alignRight,
                  ToolBarStyle.separator,
                  ToolBarStyle.image,
                  ToolBarStyle.video,
                  ToolBarStyle.separator
                ],
                toolBarColor: _toolbarColor,
                padding: const EdgeInsets.all(8),
                iconSize: 25,
                iconColor: _toolbarIconColor,
                activeIconColor: Colors.white,
                activeBackgroundColor: Colors.black,
                controller: controller,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                customButtons: [
                  Tooltip(
                      waitDuration: const Duration(milliseconds: 800),
                      message: '이미지 첨부',
                      child: InkWell(
                        onTap: () {},
                        child: const SizedBox(child: Icon(Icons.image, color: Colors.black)),
                      )),
                  Tooltip(
                      waitDuration: const Duration(milliseconds: 800),
                      message: '동영상 첨부',
                      child: InkWell(
                        onTap: () {},
                        child: const SizedBox(child: Icon(Icons.play_circle_fill_rounded, color: Colors.black)),
                      )),
                  Tooltip(
                      waitDuration: const Duration(milliseconds: 800),
                      message: '파일 첨부',
                      child: InkWell(
                        onTap: () async {
                          const fileSrc =
                              "https://storage.googleapis.com/ijit-public-gcs/user_uploads/%E1%84%89%E1%85%B5%E1%86%AF%E1%84%89%E1%85%B3%E1%86%B8%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%86%AF.xlsx";
                          const fileImgSrc = "https://storage.googleapis.com/ijit-public-gcs/static/download.png";

                          if (fileSrc.isNotEmpty) {
                            // final selectionRange = await controller.getSelectionRange();
                            //

                            // controller.insertText('''
                            // <div class="file-box">
                            //     <img class="file-icon" src="https://storage.googleapis.com/ijit-public-gcs/static/file.png" alt="파일아이콘" class="file-icon">
                            //     <span class="file-name">file.png</span>
                            // </div>
                            // ''');

                            // controller.insertText('''
                            // <a href=$fileSrc rel="noopener noreferrer" target="_blank">
                            //   <span class="ql-cursor">
                            //     파일명: 어저고 저쩌고 세상엔 진상이 너무 많다...avi<img src="https://storage.googleapis.com/ijit-public-gcs/static/download.png">
                            //   </span>
                            // </a>
                            // ''');

                            // controller.insertText('''
                            // <div class="file-box">
                            // </div>
                            // ''');
                          }
                        },
                        child: const SizedBox(child: Icon(Icons.file_present_rounded, color: Colors.black)),
                      )),
                  // Container(
                  //   width: 25,
                  //   height: 25,
                  //   decoration: BoxDecoration(
                  //       color: _hasFocus ? Colors.green : Colors.grey,
                  //       borderRadius: BorderRadius.circular(15)),
                  // ),
                  // InkWell(
                  //     onTap: () => unFocusEditor(),
                  //     child: const Icon(
                  //       Icons.favorite,
                  //       color: Colors.black,
                  //     )),
                  // InkWell(
                  //     onTap: () async {
                  //       var selectedText = await controller.getSelectedText();
                  //       debugPrint('selectedText $selectedText');
                  //       var selectedHtmlText =
                  //           await controller.getSelectedHtmlText();
                  //       debugPrint('selectedHtmlText $selectedHtmlText');
                  //     },
                  //     child: const Icon(
                  //       Icons.add_circle,
                  //       color: Colors.black,
                  //     )),
                ],
              ),
              Expanded(
                child: QuillHtmlEditor(
                  text:
                      // '''<p><img src="https://storage.googleapis.com/ijit-public-gcs/user_uploads/3uZG6idIyb.png" width="50%"></p>''',
                      '''<p><img src="https://storage.googleapis.com/ijit-public-gcs/user_uploads/4vUpSmKTmy.png" style="width: 50%;" data-original-width="724"></p>''',
                  // text: null,
                  hintText: 'Hint text goes here',
                  controller: controller,
                  isEnabled: true,
                  ensureVisible: false,
                  minHeight: minHeight,
                  autoFocus: false,
                  textStyle: _editorTextStyle,
                  hintTextStyle: _hintTextStyle,
                  hintTextAlign: TextAlign.start,
                  padding: const EdgeInsets.all(10),
                  hintTextPadding: const EdgeInsets.only(left: 20),
                  backgroundColor: _backgroundColor,
                  inputAction: InputAction.newline,
                  onEditingComplete: (s) => debugPrint('Editing completed $s'),
                  loadingBuilder: (context) {
                    return SizedBox(
                      height: minHeight,
                      child: const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.red,
                      )),
                    );
                  },
                  // onFocusChanged: (focus) {
                  //   debugPrint('has focus $focus');
                  //   setState(() {
                  //     _hasFocus = focus;
                  //   });
                  // },
                  // onTextChanged: (text) => debugPrint('widget text change $text'),
                  onEditorCreated: () {
                    debugPrint('Editor has been loaded');
                    // setHtmlText('Testing text on load');
                  },
                  onEditorResized: (height) => debugPrint('Editor resized $height'),
                  // onSelectionChanged: (sel) => debugPrint('index ${sel.index}, range ${sel.length}'),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   width: double.maxFinite,
        //   color: _toolbarColor,
        //   padding: const EdgeInsets.all(8),
        //   child: Wrap(
        //     children: [
        //       textButton(
        //           text: 'Set Text',
        //           onPressed: () {
        //             setHtmlText('This text is set by you 🫵');
        //           }),
        //       textButton(
        //           text: 'Get Text',
        //           onPressed: () {
        //             getHtmlText();
        //           }),
        //       textButton(
        //           text: 'Insert Video',
        //           onPressed: () {
        //             ////insert
        //             insertVideoURL('https://www.youtube.com/watch?v=4AoFA19gbLo');
        //             insertVideoURL('https://vimeo.com/440421754');
        //             insertVideoURL('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
        //           }),
        //       textButton(
        //           text: 'Insert Image',
        //           onPressed: () {
        //             insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
        //           }),
        //       textButton(
        //           text: 'Insert Index',
        //           onPressed: () {
        //             insertHtmlText("This text is set by the insertText method", index: 10);
        //           }),
        //       textButton(
        //           text: 'Undo',
        //           onPressed: () {
        //             controller.undo();
        //           }),
        //       textButton(
        //           text: 'Redo',
        //           onPressed: () {
        //             controller.redo();
        //           }),
        //       textButton(
        //           text: 'Clear History',
        //           onPressed: () async {
        //             controller.clearHistory();
        //           }),
        //       textButton(
        //           text: 'Clear Editor',
        //           onPressed: () {
        //             controller.clear();
        //           }),
        //       textButton(
        //           text: 'Get Delta',
        //           onPressed: () async {
        //             var delta = await controller.getDelta();
        //             debugPrint('delta');
        //             debugPrint(jsonEncode(delta));
        //           }),
        //       textButton(
        //           text: 'Set Delta',
        //           onPressed: () {
        //             final Map<dynamic, dynamic> deltaMap = {
        //               "ops": [
        //                 {
        //                   "insert": {
        //                     "video": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        //                   }
        //                 },
        //                 {
        //                   "insert": {"video": "https://www.youtube.com/embed/4AoFA19gbLo"}
        //                 },
        //                 {"insert": "Hello"},
        //                 {
        //                   "attributes": {"header": 1},
        //                   "insert": "\n"
        //                 },
        //                 {"insert": "You just set the Delta text 😊\n"}
        //               ]
        //             };
        //             controller.setDelta(deltaMap);
        //           }),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();
}
