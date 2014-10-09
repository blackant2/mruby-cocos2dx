#encoding:utf-8
begin
 include Cocos2d
 
app=Application.getInstance
app.onEnterBackground do |me|
		puts "#{me} EnterBackground "
end

app.onEnterForeground do |me|
	 puts "#{me} onEnterForeground "
end

director=Director.getInstance
d2=Director.getInstance
view=director.getOpenGLView
director.setOpenGLView(view=GLView.create('MyView'))  unless view
director.setDisplayStats(true)

director.setAnimationInterval(1.0/60)

scene = Scene.create
label=Label::createWithTTF("Hello world", "fonts/Marker Felt.ttf", 80.0);
label.setPosition(300.0,300.0);
scene.addChild(label);
director.runWithScene(scene);

rescue =>e
	puts e.inspect,e.backtrace
end
