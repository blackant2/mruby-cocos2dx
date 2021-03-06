
--------------------------------
-- @module Animate3D
-- @extend ActionInterval
-- @parent_module CC

--------------------------------
-- get & set speed, negative speed means playing reverse 
-- @function [parent=#Animate3D] getSpeed 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#Animate3D] setWeight 
-- @param self
-- @param #float weight
        
--------------------------------
-- 
-- @function [parent=#Animate3D] getOriginInterval 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#Animate3D] setSpeed 
-- @param self
-- @param #float speed
        
--------------------------------
-- get & set origin interval
-- @function [parent=#Animate3D] setOriginInterval 
-- @param self
-- @param #float interval
        
--------------------------------
-- get & set blend weight, weight must positive
-- @function [parent=#Animate3D] getWeight 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- @overload self, CC::Animation3D, float, float         
-- @overload self, CC::Animation3D         
-- @function [parent=#Animate3D] create
-- @param self
-- @param #CC::Animation3D animation
-- @param #float fromTime
-- @param #float duration
-- @return Animate3D#Animate3D ret (return value: CC::Animate3D)

--------------------------------
--  animate transition time 
-- @function [parent=#Animate3D] getTransitionTime 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- create Animate3D by frame section, [startFrame, endFrame)<br>
-- param animation used to generate animate3D<br>
-- param startFrame<br>
-- param endFrame<br>
-- param frameRate default is 30 per second<br>
-- return Animate3D created using animate
-- @function [parent=#Animate3D] createWithFrames 
-- @param self
-- @param #CC::Animation3D animation
-- @param #int startFrame
-- @param #int endFrame
-- @param #float frameRate
-- @return Animate3D#Animate3D ret (return value: CC::Animate3D)
        
return nil
