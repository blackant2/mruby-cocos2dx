#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="cocostudio"

LOCAL_SRC_FILES = %w(
ActionTimeline\CCActionTimeline.cpp
ActionTimeline\CCFrame.cpp
ActionTimeline\CCNodeReader.cpp
ActionTimeline\CCActionTimelineCache.cpp
ActionTimeline\CCTimeLine.cpp
CCActionFrame.cpp
CCActionFrameEasing.cpp
CCActionManagerEx.cpp
CCActionNode.cpp
CCActionObject.cpp
CCArmature.cpp
CCArmatureAnimation.cpp
CCArmatureDataManager.cpp
CCArmatureDefine.cpp
CCBatchNode.cpp
CCBone.cpp
CCColliderDetector.cpp
CCComAttribute.cpp
CCComAudio.cpp
CCComController.cpp
CCComRender.cpp
CCDataReaderHelper.cpp
CCDatas.cpp
CCDecorativeDisplay.cpp
CCDisplayFactory.cpp
CCDisplayManager.cpp
CCInputDelegate.cpp
CCProcessBase.cpp
CCSGUIReader.cpp
CCSkin.cpp
CCSpriteFrameCacheHelper.cpp
CCSSceneReader.cpp
CCTransformHelp.cpp
CCTween.cpp
CCUtilMath.cpp
CocoLoader.cpp
DictionaryHelper.cpp
TriggerBase.cpp
TriggerMng.cpp
TriggerObj.cpp
WidgetReader\ButtonReader\ButtonReader.cpp
WidgetReader\CheckBoxReader\CheckBoxReader.cpp
WidgetReader\ImageViewReader\ImageViewReader.cpp
WidgetReader\LayoutReader\LayoutReader.cpp
WidgetReader\ListViewReader\ListViewReader.cpp
WidgetReader\LoadingBarReader\LoadingBarReader.cpp
WidgetReader\PageViewReader\PageViewReader.cpp
WidgetReader\ScrollViewReader\ScrollViewReader.cpp
WidgetReader\SliderReader\SliderReader.cpp
WidgetReader\TextAtlasReader\TextAtlasReader.cpp
WidgetReader\TextBMFontReader\TextBMFontReader.cpp
WidgetReader\TextFieldReader\TextFieldReader.cpp
WidgetReader\TextReader\TextReader.cpp
WidgetReader\WidgetReader.cpp
)

sh=<<CMD
cl
/c
/I#{COCOS_ROOT}\\
/I#{COCOS_ROOT}\\cocos
/I#{COCOS_ROOT}\\cocos\\audio\\include
/I"#{COCOS_ROOT}\\cocos\\editor-support"
/I#{COCOS_ROOT}\\external
/I#{COCOS_ROOT}\\external\\tinyxml2
/I#{COCOS_ROOT}\\external\\chipmunk\\include\\chipmunk
/I#{COCOS_ROOT}\\extensions
/I"#{COCOS_ROOT}\\external\\win32-specific\\zlib\\include"
/I#{COCOS_ROOT}\\cocos
/I#{COCOS_ROOT}\\cocos\\platform\\win32
/I#{COCOS_ROOT}\\cocos\\platform\\desktop
/I#{COCOS_ROOT}\\external\\glfw3\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\gles\\include\\OGLES"
/W3
/WX-
/O1
/Oi
/Oy-
/D WIN32
/D _WINDOWS
/D _LIB
/D COCOS2DXWIN32_EXPORTS
/D GL_GLEXT_PROTOTYPES
/D _CRT_SECURE_NO_WARNINGS
/D _SCL_SECURE_NO_WARNINGS
/D _VARIADIC_MAX=10
/D _USING_V110_SDK71_
/D _UNICODE
/D UNICODE
/Gm-
/EHsc
/MD
/GS
/Gy
/fp:precise
/Zc:wchar_t
/Zc:forScope
/Gd
/TP
/analyze-
/errorReport:prompt
CMD
sh.gsub!("\n"," ")

FileUtils.mkdir_p("objs\\#{LIB_NAME}") unless Dir.exists?("objs\\#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f| 
	cmd=sh
	if f.include?('\\')
	  i=f.rindex('\\')
	  FileUtils.mkdir_p "objs\\#{LIB_NAME}\\#{f[0,i]}" unless Dir.exists? "objs\\#{LIB_NAME}\\#{f[0,i]}"
	  cmd+="/Fo\".\\objs\\#{LIB_NAME}\\#{f[0,i]}\\\\\" "
  	else
  	  cmd+="/Fo\".\\objs\\#{LIB_NAME}\\\\\" "
  	end
  	next if File.exists? "objs\\#{LIB_NAME}\\#{f.gsub(/\.c(pp)?$/,'.obj')}"
	cmd+=" #{COCOS_ROOT}\\cocos\\editor-support\\cocostudio\\"+f
	puts cmd
	system cmd 
	
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} "
LOCAL_SRC_FILES.each do |f| 
	sh<<"  .\\objs\\#{LIB_NAME}\\#{f.sub(/\.c(pp)?$/,'.obj')}"
end
sh<<" /OUT:lib/#{LIB_NAME}.lib"
puts sh
system sh


