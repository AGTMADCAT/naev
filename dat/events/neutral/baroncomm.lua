--[[
-- Comm Event for the Crazy Baron mission string
--]]


function create ()
    hyena = pilot.add("Civilian Hyena")[1]
    
    hook.pilot(hyena, "jump", "finish")
    hook.pilot(hyena, "death", "finish")
    hook.land("finish")
    hook.jumpout("finish")
    
    hailie = evt.timerStart("hailme", 3000)
end

-- Make the ship hail the player
function hailme()
    tk.msg("TODO", "bobbens, fix your shit.")
    hook.pilot(hyena, "hail", "hail")
end

-- Triggered when the player hails the ship
function hail()
    evt.misnStart("Baron")
    evt.finish(true)
end

function finish()
    evt.timerStop(hailie)
    evt.finish()
end