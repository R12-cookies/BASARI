import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:after_layout/after_layout.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class ChatSplash extends StatefulWidget {
  @override
  _ChatSplashState createState() => _ChatSplashState();
}

class _ChatSplashState extends State<ChatSplash>
    with AfterLayoutMixin<ChatSplash> {
  FlutterTts flutterTts;

  dynamic ttsState;
  bool check = false;
  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("ar");
    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak(String word) async {
    await flutterTts.awaitSpeakCompletion(true);
    if (ttsState == TtsState.playing) {
      var result = await flutterTts.stop();
      if (result == 1) {
        print(result);
        setState(() {
          ttsState = TtsState.stopped;
          check = true;
        });
        await new Future.delayed(const Duration(seconds: 1));
        _speak(word);
      }
    } else {
      await flutterTts.speak(word);
    }
  }

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen4 = (prefs.getBool('seen4') ?? false);

    if (_seen4) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new ChatScreen()));

      //is there away to block any interactions until the audio finishes
      // intro to home audio
    } else {
      await prefs.setBool('seen4', true);
      _speak(
          ' مَرْحَبًَا بِكَ فِي لَوْحَةِ الْمَفَاتِيحِ، اللَّوْحَةُ مُقَسَّمَةٌ لِأَرْبَعَةِ صَفَحَات، وَ كُلَّ صَفْحَةِ مُقَسَّمَةٌبالتَّساوي لِتُسْعَةِ أَجْزَاءٍ أَوْ مُرَبَّعاتٌ يَحْتَوِي كُلُّ مَرَبَعٍ عَلَى حَرْفٍ مِنْ حُروفِ الأَبْجَدِيَّةِ الْعَرَبِيَّةَ، مُرَتبََةٌ حَسَبِ التَّرْتِيبِ الْأبْجَدِيِّ مِنَ الْيَمِينِ إِلَى الْيَسَارِ هَذَا يَعْنِي أَنَّ أَوَّلَ حَرْفٍ مِنَ الأَبَجَدِيَّة، حَرْفَ الْأَلِفْ سَيَكُونُ أقْصَى يَمِينَ أَعْلَى الشَّاشَةِ، بِنَفْسُ التَّرْتِيبِ سَيَكُونُ حَرْفُ الذَّالِ، تَاسِعُ حَرْفٍ فِي الأَبَجَدِيَّة وَ آخِّرُ حَرْفٍ فِي الصَّفْحَةِ الْأوْلَى، أَقْصَى يَسَارُ أَسْفَلِ الشَّاشَةِ. بَاقِيُّ الْحُروفِ مُوَزَّعَةٌ فِي بَاقِيُّ الصَّفَحات بِنَفْسُ التَّرْتِيبِ وَ الشَّكْلُ . يُمْكِنُكَ السَّحْبُ اُفقِيَّا لِتَغْيِيرِ الصَّفْحَةِ. آخِّرُ صَفْحَةً تَحْوِي آخِّرُ حَرْفٍ مِنْ حُروفِ الأَبْجَدِيَّةِ ، حَرْفَ الْيَاء وَبَعْدَهَا تَأْتِي مُشْتَقَّاتٌ الْأَلِفُ بِالتَّرْتِيبِ . التَّالِي. هَمْزَةً.الْأَلِفُ الْمَكسورَةُ. الْأَلِفُ بِالْهَمْزَةِ . الْأَلِفُ الْمَقْصُورَةُ. الْأَلِفُ الْمَقْصُورَةُ بِالْهَمْزَةِ.وَ الْوَاو بِالْهَمْزَةِ إِذَا نَسِيتَ هَذِهِ الْمَعْلُومَاتِ هَزَّ الْهَاتِفُ وَ سَنُذَكِّرُكَ');

      Timer(Duration(seconds: 48), () {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new ChatScreen()));
      });
      //home audio(simple hello)
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _ChatScreenState extends State<ChatScreen> {
  String _swipeDirection = "";
  FlutterTts flutterTts;
  String s = "";

  TabController _tabController;
  dynamic ttsState;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget createButton(String word) {
    return InkWell(
      onTap: () {
        if (word == "ى") {
          _speak(" الألف المقصورة");
        } else if (word == "إ") {
          _speak(" الْأَلِفُ المكسورة");
        } else {
          _speak(word);
        }
        s = s + word;
        print(s);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        color: Colors.black,
        child: Center(
          child: Text(
            '$word',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
        shakeThresholdGravity: 2.5,
        onPhoneShake: () {
          _speak(
              " اِسحَب أُفُقِيّا للتنقل بين الصَّفحات. اٌنقُر مرة لكتابةِ حرف. و قم بِالسَّحْب  للاعلى لقراءة الرسالة و مرة أخرى لارسال الرسالة,  ضغطة مطولة لِإِضَافَة فراغ  و سحبةٌ لِلْأَسْفَل لحدف آخِرِ حَرْفٍ .آخر صفحة تحوي آخر حرفٍ من حروفِ الأبجدية. حرف الياء وبعدها تأتي مشتقات الألف بالترتيب التالي. الْهَمْزَة .الألف المكسورة. الألف بالهمزة. الألف المقصورة. الألف المقصورة بالهمزة. و الواو بالهمزة");
        });
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("ar");
    flutterTts.setSpeechRate(1);
    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future _speak(String word) async {
    await flutterTts.awaitSpeakCompletion(false);
    if (ttsState == TtsState.playing) {
      var result = await flutterTts.stop();
      if (result == 1) {
        setState(() {
          ttsState = TtsState.stopped;
        });

        _speak(word);
      }
    } else {
      await flutterTts.speak(word);
    }
  }

  ShakeDetector detector;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  _speak('الصفحة التالية');
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  
                },
                onDoubleTap: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => new Home()));
                },
                onLongPress: () {
                  s = s + ' ';
                  print(s);
                },
                onVerticalDragEnd: (dragEndDetails) {
                  if (dragEndDetails.primaryVelocity < 0) {
                    // swipeup
                    if (!mounted) return;
                    setState(() {
                      _swipeDirection = "Swipe Up";
                    });
                    if (s.length > 0) {
                      _speak("$s");
                      setState(() {
                        
                      });
                    } else {
                      _speak("الرسالة فارغة");
                    }
                  } else if (dragEndDetails.primaryVelocity > 0) {
                    // swipedown
                    if (!mounted) return;
                    setState(() {
                      _swipeDirection = "Swipe Down";
                    });
                    if (s.length > 0) {
                      _speak("تم حَذف اَخِرِ حرف");
                    } else {
                      _speak("الرسالة فارغة");
                    }
                    if (!mounted) return;
                    setState(() {
                      s = s.substring(0, s.length - 1);
                      print(s);
                    });
                  }
                },
                child:
                    TabBarView(controller: _tabController, children: <Widget>[
                  GridView.count(
                    childAspectRatio: height < 550
                        ? 0.71
                        : height < 650 ? 0.68 : height < 700 ? 0.58 : 0.50,
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    // Generate 100 widgets that display their index in the List.
                    children: [
                      createButton("ا"),
                      createButton("ب"),
                      createButton("ت"),
                      createButton("ث"),
                      createButton("ج"),
                      createButton("ح"),
                      createButton("خ"),
                      createButton("د"),
                      createButton("ذ"),
                    ],
                  ),
                  GridView.count(
                    childAspectRatio: height < 550
                        ? 0.71
                        : height < 650 ? 0.68 : height < 700 ? 0.64 : 0.50,
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    // Generate 100 widgets that display their index in the List.
                    children: [
                      createButton("ر"),
                      createButton("ز"),
                      createButton("س"),
                      createButton("ش"),
                      createButton("ص"),
                      createButton("ض"),
                      createButton("ط"),
                      createButton("ظ"),
                      createButton("ع"),
                    ],
                  ),
                  GridView.count(
                    childAspectRatio: height < 550
                        ? 0.71
                        : height < 650 ? 0.68 : height < 700 ? 0.64 : 0.50,
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    // Generate 100 widgets that display their index in the List.
                    children: [
                      createButton("غ"),
                      createButton("ف"),
                      createButton("ق"),
                      createButton("ك"),
                      createButton("ل"),
                      createButton("م"),
                      createButton("ن"),
                      createButton("ه"),
                      createButton("و"),
                    ],
                  ),
                  GridView.count(
                    childAspectRatio: height < 550
                        ? 0.71
                        : height < 650 ? 0.68 : height < 700 ? 0.64 : 0.50,
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    // Generate 100 widgets that display their index in the List.
                    children: [
                      createButton("ي"),
                      createButton("ء"),
                      createButton("إ"),
                      createButton("ى"),
                      createButton("ئ"),
                      createButton("ؤ"),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
