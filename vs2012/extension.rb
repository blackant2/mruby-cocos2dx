#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="extension"

LOCAL_SRC_FILES = %w(
assets-manager\AssetsManager.cpp
GUI\CCControlExtension\CCControl.cpp
GUI\CCControlExtension\CCControlButton.cpp
GUI\CCControlExtension\CCControlColourPicker.cpp
GUI\CCControlExtension\CCControlHuePicker.cpp
GUI\CCControlExtension\CCControlPotentiometer.cpp
GUI\CCControlExtension\CCControlSaturationBrightnessPicker.cpp
GUI\CCControlExtension\CCControlSlider.cpp
GUI\CCControlExtension\CCControlStepper.cpp
GUI\CCControlExtension\CCControlSwitch.cpp
GUI\CCControlExtension\CCControlUtils.cpp
GUI\CCControlExtension\CCInvocation.cpp
GUI\CCControlExtension\CCScale9Sprite.cpp
GUI\CCEditBox\CCEditBox.cpp
GUI\CCEditBox\CCEditBoxImplWin.cpp
GUI\CCScrollView\CCScrollView.cpp
GUI\CCScrollView\CCTableView.cpp
GUI\CCScrollView\CCTableViewCell.cpp 
physics-nodes\CCPhysicsDebugNode.cpp
physics-nodes\CCPhysicsSprite.cpp
proj.win32\Win32InputBox.cpp
)

sh=<<CMD
cl
/c
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\
/I#{COCOS_ROOT}\\cocos\\audio\\include
/I#{COCOS_ROOT}\\external
/I#{COCOS_ROOT}\\external\\unzip
/I#{COCOS_ROOT}\\external\\chipmunk\\include\\chipmunk
/I#{COCOS_ROOT}\\external\\curl\\include\\win32
/I#{COCOS_ROOT}\\external\\sqlite3\\include
/I#{COCOS_ROOT}\\external\\libwebsockets\\win32\\include
/I"#{COCOS_ROOT}\\external\\win32-specific\\zlib\\include"
/I#{COCOS_ROOT}\\extensions\\
/I#{COCOS_ROOT}\\cocos
/I#{COCOS_ROOT}\\cocos\\platform\\win32
/I#{COCOS_ROOT}\\cocos\\platform\\desktop
/I#{COCOS_ROOT}\\external\\glfw3\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\gles\\include\\OGLES"
/W3
/WX-
/MP
/O1
/Oi
/Oy-
/D WIN32
/D _WINDOWS
/D NDEBUG
/D _LIB
/D CC_ENABLE_CHIPMUNK_INTEGRATION=1
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
/wd4267
/wd4251
/wd4244
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
	cmd+=" #{COCOS_ROOT}\\extensions\\"+f
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



