#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="cocosbuilder"

LOCAL_SRC_FILES = %w(
CCBAnimationManager.cpp
CCBFileLoader.cpp
CCBKeyframe.cpp
CCBReader.cpp
CCBSequence.cpp
CCBSequenceProperty.cpp
CCControlButtonLoader.cpp
CCControlLoader.cpp
CCLabelBMFontLoader.cpp
CCLabelTTFLoader.cpp
CCLayerColorLoader.cpp
CCLayerGradientLoader.cpp
CCLayerLoader.cpp
CCMenuItemImageLoader.cpp
CCMenuItemLoader.cpp
CCNode+CCBRelativePositioning.cpp
CCNodeLoader.cpp
CCNodeLoaderLibrary.cpp
CCParticleSystemQuadLoader.cpp
CCScale9SpriteLoader.cpp
CCScrollViewLoader.cpp
CCSpriteLoader.cpp
)

sh=<<CMD
cl
/c
/I#{COCOS_ROOT}\\
/I#{COCOS_ROOT}\\extensions
/I#{COCOS_ROOT}\\cocos\\audio\\include
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
	cmd+=" #{COCOS_ROOT}\\cocos\\editor-support\\cocosbuilder\\"+f
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


