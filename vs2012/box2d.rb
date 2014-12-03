#encoding:utf-8

require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
LIB_NAME="box2d"
AR="lib"

LOCAL_SRC_FILES = %w(
Collision\b2BroadPhase.cpp 
Collision\b2CollideCircle.cpp 
Collision\b2CollideEdge.cpp 
Collision\b2CollidePolygon.cpp 
Collision\b2Collision.cpp 
Collision\b2Distance.cpp 
Collision\b2DynamicTree.cpp 
Collision\b2TimeOfImpact.cpp 
Collision\Shapes\b2ChainShape.cpp 
Collision\Shapes\b2CircleShape.cpp 
Collision\Shapes\b2EdgeShape.cpp 
Collision\Shapes\b2PolygonShape.cpp 
Common\b2BlockAllocator.cpp 
Common\b2Draw.cpp 
Common\b2Math.cpp 
Common\b2Settings.cpp 
Common\b2StackAllocator.cpp 
Common\b2Timer.cpp 
Dynamics\b2Body.cpp 
Dynamics\b2ContactManager.cpp 
Dynamics\b2Fixture.cpp 
Dynamics\b2Island.cpp 
Dynamics\b2World.cpp 
Dynamics\b2WorldCallbacks.cpp 
Dynamics\Contacts\b2ChainAndCircleContact.cpp 
Dynamics\Contacts\b2ChainAndPolygonContact.cpp 
Dynamics\Contacts\b2CircleContact.cpp 
Dynamics\Contacts\b2Contact.cpp 
Dynamics\Contacts\b2ContactSolver.cpp 
Dynamics\Contacts\b2EdgeAndCircleContact.cpp 
Dynamics\Contacts\b2EdgeAndPolygonContact.cpp 
Dynamics\Contacts\b2PolygonAndCircleContact.cpp 
Dynamics\Contacts\b2PolygonContact.cpp 
Dynamics\Joints\b2DistanceJoint.cpp 
Dynamics\Joints\b2FrictionJoint.cpp 
Dynamics\Joints\b2GearJoint.cpp 
Dynamics\Joints\b2Joint.cpp 
Dynamics\Joints\b2MotorJoint.cpp 
Dynamics\Joints\b2MouseJoint.cpp 
Dynamics\Joints\b2PrismaticJoint.cpp 
Dynamics\Joints\b2PulleyJoint.cpp 
Dynamics\Joints\b2RevoluteJoint.cpp 
Dynamics\Joints\b2RopeJoint.cpp 
Dynamics\Joints\b2WeldJoint.cpp 
Dynamics\Joints\b2WheelJoint.cpp 
Rope\b2Rope.cpp
)

sh=<<CMD
cl
/c
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\external
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
  	next if File.exists? "objs\\#{LIB_NAME}\\#{f.gsub(/\.cpp/,'.obj')}"
	cmd+=" #{COCOS_ROOT}\\external\\box2d\\"+f
	puts cmd
	system cmd 
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} "
LOCAL_SRC_FILES.each do |f| 
	sh<<"  .\\objs\\#{LIB_NAME}\\#{f.sub(/\.cpp/,'.obj')}"
end
sh<<" /OUT:lib/#{LIB_NAME}.lib"
puts sh
system sh