
--------------------------------
-- @module WavesTiles3D
-- @extend TiledGrid3DAction
-- @parent_module CC

--------------------------------
--  waves amplitude rate 
-- @function [parent=#WavesTiles3D] getAmplitudeRate 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#WavesTiles3D] setAmplitude 
-- @param self
-- @param #float amplitude
        
--------------------------------
-- 
-- @function [parent=#WavesTiles3D] setAmplitudeRate 
-- @param self
-- @param #float amplitudeRate
        
--------------------------------
--  waves amplitude 
-- @function [parent=#WavesTiles3D] getAmplitude 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- creates the action with a number of waves, the waves amplitude, the grid size and the duration <br>
-- param duration in seconds
-- @function [parent=#WavesTiles3D] create 
-- @param self
-- @param #float duration
-- @param #size_table gridSize
-- @param #unsigned int waves
-- @param #float amplitude
-- @return WavesTiles3D#WavesTiles3D ret (return value: CC::WavesTiles3D)
        
return nil
