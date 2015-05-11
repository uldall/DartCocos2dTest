import 'dart:html';
import 'dart:js';

class CocosInitializer {
    
  void _removeLoadingScreen() {
    var isNative = context["cc"]["sys"]["isNative"];
    if (!isNative && querySelector('#cocosLoading') != null) {
      querySelector('#cocosLoading').remove();
    }
  }
  
  void _setViewSettings() {
    var ccView = context["cc"]["view"];
    ccView.callMethod("enableRetina", [false]);
    ccView.callMethod("adjustViewPort", [true]);
    ccView.callMethod("setDesignResolutionSize", [800, 450, context["cc"]["ResolutionPolicy"]["SHOW_ALL"]]);
    ccView.callMethod("resizeWithBrowserSize", [true]);
  }
  
  Map _getResources() {
    Map res = {
        "HelloWorld_png" : "res/HelloWorld.png",
        "CloseNormal_png" : "res/CloseNormal.png",
        "CloseSelected_png" : "res/CloseSelected.png"
    };
    
    return res;
  }
  
  void _onStart() {
    _removeLoadingScreen();
    
    _setViewSettings();

    _getResources();
    
    context["cc"]["LoaderScene"].callMethod("preload", [new JsObject.jsify(_getResources().values), _createScenes, context["this"]]);
  }
  
  void _createScenes() {
    var sceneCollectionJS = new JsObject.jsify({ "onEnter": _onEnter});
    context["HelloWorldScene"] = context["cc"]["Scene"].callMethod("extend", [sceneCollectionJS]);
    
    context["cc"]["director"].callMethod("runScene", [new JsObject(context["HelloWorldScene"], [])]);
  }
  
  void _onEnter() {
    context["this"].callMethod("_super", []);
  }
  
  void run() {
    context["cc"]["game"]["onStart"] = _onStart;
    context["cc"]["game"].callMethod("run");
  }
}

main() async {
  CocosInitializer initializer = new CocosInitializer();
  initializer.run();
}