#encoding:utf-8

require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
LIB_NAME="audio"
AR="lib"

LOCAL_SRC_FILES = %w(MciPlayer.cpp SimpleAudioEngine.cpp )

sh=<<CMD
cl /c 
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\cocos\\audio\\Include
/I#{COCOS_ROOT}\\cocos\\2d\\..\\..\\cocos 
/I#{COCOS_ROOT}\\cocos\\2d\\..\\..\\cocos\\platform\\win32 
/I#{COCOS_ROOT}\\cocos\\2d\\..\\..\\cocos\\platform\\desktop 
/I#{COCOS_ROOT}\\cocos\\2d\\..\\..\\external\\glfw3\\include\\win32 
/I"#{COCOS_ROOT}\\cocos\\2d\\..\\..\\external\\win32-specific\\gles\\include\\OGLES"  
/W3 
/WX- 
/MP 
/O1 
/Oy- 
/D WIN32 
/D NDEBUG 
/D _WINDOWS 
/D _CRT_SECURE_NO_WARNINGS 
/D _VARIADIC_MAX=10 
/D _USING_V110_SDK71_ 
/Gm- 
/EHsc 
/MD 
/GS 
/fp:precise 
/Zc:wchar_t 
/Zc:forScope 

/Gd 
/TP 
/wd4251 
/analyze- 
/errorReport:prompt
CMD

sh.gsub!("\n"," ")

FileUtils.mkdir_p("objs\\#{LIB_NAME}") unless Dir.exists?("objs\\#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f| 
	if f.include?('\\')
	  i=f.rindex('\\')
	  FileUtils.mkdir_p "objs\\#{LIB_NAME}\\#{f[0,i]}" unless Dir.exists? "objs\\#{LIB_NAME}\\#{f[0,i]}"
  	end
  	next if File.exists? "objs\\#{LIB_NAME}\\#{f.gsub(/\.cpp/,'.obj')}"
	cmd= sh+"/Fo"".\\objs\\#{LIB_NAME}\\\\"" "+" #{COCOS_ROOT}\\cocos\\audio\\win32\\"+f
	puts cmd
	system cmd 
	break
end


FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} "
LOCAL_SRC_FILES.each do |f| 
	sh<<"  .\\objs\\#{LIB_NAME}\\#{f.sub(/\.cpp/,'.obj')}"
end
sh<<" /OUT:lib/#{LIB_NAME}.lib"
puts sh
system sh
