
--------------------------------
-- @module DirectionLight
-- @extend BaseLight
-- @parent_module CC

--------------------------------
-- Returns the Direction in parent.
-- @function [parent=#DirectionLight] getDirection 
-- @param self
-- @return vec3_table#vec3_table ret (return value: vec3_table)
        
--------------------------------
-- Returns direction in world.
-- @function [parent=#DirectionLight] getDirectionInWorld 
-- @param self
-- @return vec3_table#vec3_table ret (return value: vec3_table)
        
--------------------------------
-- Sets the Direction in parent.<br>
-- param dir The Direction in parent.
-- @function [parent=#DirectionLight] setDirection 
-- @param self
-- @param #vec3_table dir
        
--------------------------------
-- Creates a direction light.<br>
-- param direction The light's direction<br>
-- param color The light's color.<br>
-- return The new direction light.
-- @function [parent=#DirectionLight] create 
-- @param self
-- @param #vec3_table direction
-- @param #color3b_table color
-- @return DirectionLight#DirectionLight ret (return value: CC::DirectionLight)
        
return nil
