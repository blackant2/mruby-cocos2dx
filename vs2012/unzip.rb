#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="unzip"

LOCAL_SRC_FILES = %w(
unzip\ioapi.cpp
unzip\unzip.cpp
)

sh=<<CMD
cl
/c
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\external\\sqlite3\\include
/I#{COCOS_ROOT}\\external\\unzip
/I#{COCOS_ROOT}\\external\\edtaa3func
/I#{COCOS_ROOT}\\external\\tinyxml2
/I#{COCOS_ROOT}\\external\\png\\include\\win32
/I#{COCOS_ROOT}\\external\\jpeg\\include\\win32
/I#{COCOS_ROOT}\\external\\tiff\\include\\win32
/I#{COCOS_ROOT}\\external\\webp\\include\\win32
/I#{COCOS_ROOT}\\external\\freetype2\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\icon\\include"
/I"#{COCOS_ROOT}\\external\\win32-specific\\zlib\\include"
/I#{COCOS_ROOT}\\external\\chipmunk\\include\\chipmunk
/I#{COCOS_ROOT}\\external\\xxhash
/I#{COCOS_ROOT}\\external\\ConvertUTF
/I#{COCOS_ROOT}\\external
/I#{COCOS_ROOT}\\cocos
/I#{COCOS_ROOT}\\cocos\\platform\\win32
/I#{COCOS_ROOT}\\cocos\\platform\\desktop
/I#{COCOS_ROOT}\\external\\glfw3\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\gles\\include\\OGLES"
/W3
/WX-
/MP
/O1
/Oy-
/D WIN32
/D NDEBUG
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
	cmd+=" #{COCOS_ROOT}\\external\\"+f
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


