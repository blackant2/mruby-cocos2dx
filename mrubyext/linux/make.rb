##encoding:utf-8

require 'fileutils'

MRUBY_ROOT='/home/ker/mruby'
COCOS_ROOT='/home/ker/cocos2dx'
# -frtti
opts=%w(-std=c++11 -DLINUX -DEBUG -Wno-deprecated-declarations
-DCC_ENABLE_CHIPMUNK_INTEGRATION=1  -DCOCOS2D_DEBUG=1 -fPIC
)
libs=%w(
mruby   
cocos2d
cocosplatform
tinyxml2
unzip
chipmunk
xxhash 
jpeg
webp
tiff
edtaa3
ConvertUTF
freetype
fontconfig
png
pthread
glfw
GLEW
GL
X11
z
stdc++ 
pthread
m
rt
dl    
)

lib_paths=%w(.)
include_paths=%w(../ext)


lib_paths<<"#{MRUBY_ROOT}/build/host/lib"
lib_paths<<"#{COCOS_ROOT}/linux/lib"
include_paths<<"#{COCOS_ROOT}/cocos/platform/linux"
include_paths<<"#{MRUBY_ROOT}/include"
include_paths<<"#{COCOS_ROOT}/cocos"
include_paths<<"/usr/local/include/GLFW"



FileUtils.mkdir_p("objs") unless Dir.exists? 'objs' 

src=[]
['../ext/linux/*.cpp','../ext/*.cpp','./*.cpp'].each do |p|
	  
		Dir.glob(p) do |f|
	     fn=  (/([\w]+)\.cpp/i).match(f)[1]
	     src.push fn
	     next if File.exists? "objs/#{fn}.o"
	     sh="gcc"
	     include_paths.each{|ip| sh<<" -I#{ip}"}
	     	sh<<" -c #{f} -o objs/#{fn}.o "
	     	sh<<opts.join(' ')
	     	puts sh 
	      system sh
	  end
end

sh="gcc -g"
include_paths.each{|p| sh<<" -I#{p}"}
lib_paths.each{|p| sh<<" -L#{p}"}
src.each do |f|
		sh<< " objs/#{f}.o"
end
sh<<" "
sh<<opts.join(' ')
sh<<libs.map{|x| " -l#{x}"}.join('')
sh<<" -o main"
puts sh
system sh
#system('./main')
