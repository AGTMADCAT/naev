--[[
-- Derelict Event, spawning either the FLF prelude mission string or the Dvaered anti-FLF string.
--]]

lang = naev.lang()
if lang == "es" then
    -- not translated atm
else -- default english 

-- Text
    text = {}
    title = {}
    
    broadcastmsgDV = "SOS. This is %s. Primary systems down. Requesting assistance."
    broadcastmsgFLF = "Calling all ships. This is %s. Engines down, ship damaged. Please help."
    shipnameDV = "Dvaered Patrol"
    shipnameFLF = "Frontier Patrol"
end 

function create()

    -- Create the derelicts One Dvaered, one FLF.
    pilot.toggleSpawn(false)
    pilot.clear()
    
    posDV = vec2.new(-1000, 0)
    posFLF = vec2.new(1000, 0)
    
    fleetDV = pilot.add("Dvaered Vendetta", "dummy", posDV, false)
    shipDV = fleetDV[1]
    fleetFLF = pilot.add("FLF Vendetta", "dummy", posFLF, false)
    shipFLF = fleetFLF[1]
    
    shipDV:disable()
    shipFLF:disable()
    
    shipDV:rename(shipnameDV)
    shipFLF:rename(shipnameFLF)
    
    timerDV = evt.timerStart("broadcastDV", 3000) 
    timerFLF = evt.timerStart("broadcastFLF", 5000) 
    
    boarded = false
    destroyed = false

    -- Set a bunch of vars, for no real reason
    var.push("flfbase_angle", rnd.rnd() * 2 * math.pi)
    var.push("flfbase_sysname", "Sigur")
    
    hook.pilot(shipDV, "board", "boardDV")
    hook.pilot(shipDV, "death", "deathDV")
    hook.pilot(shipFLF, "board", "boardFLF")
    hook.pilot(shipFLF, "death", "deathFLF")
    hook.enter("enter")
end

function broadcastDV()
    -- Ship broadcasts an SOS every 10 seconds, until boarded or destroyed.
    shipDV:broadcast(string.format(broadcastmsgDV, shipnameDV), true)
    timerDV = evt.timerStart("broadcastDV", 10000)
end

function broadcastFLF()
    -- Ship broadcasts an SOS every 10 seconds, until boarded or destroyed.
    shipFLF:broadcast(string.format(broadcastmsgFLF, shipnameFLF), true)
    timerFLF = evt.timerStart("broadcastFLF", 10000)
end

function boardFLF()
    shipDV:setNoboard(true)
    evt.timerStop(timerFLF)
    player.unboard()
    evt.misnStart("Save the FLF agent") 
end

function deathDV()
    evt.timerStop(timerDV)
    destroyed = true
    if shipFLF:alive() == false then
        destroyevent()
    end
end

function boardDV()
    shipFLF:setNoboard(true)
    evt.timerStop(timerDV)
    player.unboard()
    evt.misnStart("Take the Dvared crew home") 
end

function deathFLF()
    evt.timerStop(timerFLF)
    destroyed = true
    if shipDV:alive() == false then
        destroyevent()
    end
end

function enter()
    if boarded == true then
        destroyevent()
    else
        evt.finish(false)
    end
end

function destroyevent()
    evt.finish(true)
end
