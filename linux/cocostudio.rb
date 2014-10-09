##encoding:utf-8
require 'fileutils'


COCOS_ROOT="/home/ker/cocos2dx"
CC="c++"
AR="ar"
LIB_NAME="cocostudio"

LOCAL_SRC_FILES = %w(
CCActionFrame.cpp
CCActionFrameEasing.cpp
CCActionManagerEx.cpp
CCActionNode.cpp
CCActionObject.cpp
CCArmature.cpp
CCBone.cpp
CCArmatureAnimation.cpp
CCProcessBase.cpp
CCTween.cpp
CCDatas.cpp
CCBatchNode.cpp
CCDecorativeDisplay.cpp
CCDisplayFactory.cpp
CCDisplayManager.cpp
CCSkin.cpp
CCColliderDetector.cpp
CCArmatureDataManager.cpp
CCArmatureDefine.cpp
CCDataReaderHelper.cpp
CCSpriteFrameCacheHelper.cpp
CCTransformHelp.cpp
CCUtilMath.cpp
CCComAttribute.cpp
CCComAudio.cpp
CCComController.cpp
CCComRender.cpp
CCInputDelegate.cpp
DictionaryHelper.cpp
CCSGUIReader.cpp
CCSSceneReader.cpp
TriggerBase.cpp
TriggerMng.cpp
TriggerObj.cpp
CocoLoader.cpp
WidgetReader/WidgetReader.cpp
WidgetReader/ButtonReader/ButtonReader.cpp
WidgetReader/CheckBoxReader/CheckBoxReader.cpp
WidgetReader/ImageViewReader/ImageViewReader.cpp
WidgetReader/LayoutReader/LayoutReader.cpp
WidgetReader/ListViewReader/ListViewReader.cpp
WidgetReader/LoadingBarReader/LoadingBarReader.cpp
WidgetReader/PageViewReader/PageViewReader.cpp
WidgetReader/ScrollViewReader/ScrollViewReader.cpp
WidgetReader/SliderReader/SliderReader.cpp
WidgetReader/TextAtlasReader/TextAtlasReader.cpp
WidgetReader/TextBMFontReader/TextBMFontReader.cpp
WidgetReader/TextFieldReader/TextFieldReader.cpp
WidgetReader/TextReader/TextReader.cpp
ActionTimeline/CCActionTimeline.cpp
ActionTimeline/CCActionTimelineCache.cpp
ActionTimeline/CCFrame.cpp
ActionTimeline/CCNodeReader.cpp
ActionTimeline/CCTimeLine.cpp)


FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
   sh="#{CC} -DCC_ENABLE_CHIPMUNK_INTEGRATION=1"
		sh<<" -DLINUX"
		sh<<" -std=c++11"
		sh<<" -g"
		sh<<" -Wall"
		sh<<" -DCOCOS2D_DEBUG=1"
		sh<<" -fPIC"
		sh<<" -I#{COCOS_ROOT}"
		sh<<" -I#{COCOS_ROOT}/cocos"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/desktop"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/linux"
		sh<<" -I#{COCOS_ROOT}/cocos/audio/include"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support"
		sh<<" -I#{COCOS_ROOT}/cocos/scripting/lua-bindings/auto"
		sh<<" -I#{COCOS_ROOT}/cocos/scripting/lua-bindings/manual"
		sh<<" -I#{COCOS_ROOT}/extensions"
		sh<<" -I#{COCOS_ROOT}/external"
		sh<<" -I#{COCOS_ROOT}/external/tinyxml2"
		sh<<" -I#{COCOS_ROOT}/external/unzip"
		sh<<" -I#{COCOS_ROOT}/external/edtaa3func"
		sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/external/jpeg/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/png/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/tiff/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/webp/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/glfw3/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/websockets/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/xxhash"
		sh<<" -I#{COCOS_ROOT}/external/xxtea"
		sh<<" -I/usr/include/GLFW"
		sh<<" -I/usr/local/include/GLFW"
		sh<<" -I#{COCOS_ROOT}/external/linux-specific/fmod/include/64-bit"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/cocostudio/..   "
		sh<<" -o objs/#{LIB_NAME}/#{f}.o"
		sh<<" -c #{COCOS_ROOT}/cocos/editor-support/cocostudio/#{f}"
   	puts sh
		system sh
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} crsD lib/lib#{LIB_NAME}.a"

LOCAL_SRC_FILES.each do |f|
	  sh<<" ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh

