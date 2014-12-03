#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="chipmunk"

LOCAL_SRC_FILES = %w(
src\chipmunk.c 
src\cpArbiter.c 
src\cpArray.c 
src\cpBB.c 
src\cpBBTree.c 
src\cpBody.c 
src\cpCollision.c 
src\cpHashSet.c 
src\cpPolyShape.c 
src\cpShape.c 
src\cpSpace.c 
src\cpSpaceComponent.c 
src\cpSpaceHash.c 
src\cpSpaceQuery.c 
src\cpSpaceStep.c 
src\cpSpatialIndex.c 
src\cpSweep1D.c 
src\cpVect.c 
src\constraints\cpConstraint.c 
src\constraints\cpDampedRotarySpring.c 
src\constraints\cpDampedSpring.c 
src\constraints\cpGearJoint.c 
src\constraints\cpGrooveJoint.c 
src\constraints\cpPinJoint.c 
src\constraints\cpPivotJoint.c 
src\constraints\cpRatchetJoint.c 
src\constraints\cpRotaryLimitJoint.c 
src\constraints\cpSimpleMotor.c 
src\constraints\cpSlideJoint.c
)

sh=<<CMD
cl
/c
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\external\\chipmunk\\include\\chipmunk
/W3
/WX-
/MP
/O1
/Oy-
/D WIN32
/D NDEBUG
/D _LIB
/D _USING_V110_SDK71_
/D _UNICODE
/D UNICODE
/Gm-
/EHsc
/MD
/GS
/fp:precise
/Zc:wchar_t-
/Zc:forScope
/Gd
/TP
/wd4068
/wd4996
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
  	next if File.exists? "objs\\#{LIB_NAME}\\#{f.gsub(/\.c$/,'.obj')}"
	cmd+=" #{COCOS_ROOT}\\external\\chipmunk\\"+f
	puts cmd
	system cmd 
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} "
LOCAL_SRC_FILES.each do |f| 
	sh<<"  .\\objs\\#{LIB_NAME}\\#{f.sub(/\.c$/,'.obj')}"
end
sh<<" /OUT:lib/#{LIB_NAME}.lib"
puts sh
system sh