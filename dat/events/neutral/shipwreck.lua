--[[
-- Shipwreck Event
--
-- Creates a wrecked ship that asks for help. If the player boards it, the event switches to the Space Family mission.
-- See dat/missions/neutral/spacefamily.lua
--]]

lang = naev.lang()
if lang == "es" then
    -- not translated atm
else -- default english 

-- Text
    broadcastmsg = "SOS. This is %s. We are shipwrecked. Requesting immediate assistance."
    shipname = "August" --The ship will have a unique name
end

function create ()

    -- The shipwrech will be a random trader vessel.
    r = rnd.rnd()
    if r > 0.95 then
        ship = "Trader Gawain"
    elseif r > 0.8 then
        ship = "Trader Mule"
    elseif r > 0.5 then
        ship = "Trader Koala"
    else 
        ship = "Trader Llama"
    end

    -- Create the derelict.
    angle = rnd.rnd() * 2 * math.pi
    dist  = rnd.rnd(2000, 3000) -- place it a ways out
    pos   = vec2.new( dist * math.cos(angle), dist * math.sin(angle) )
    p     = pilot.add(ship, "dummy", pos, false)
    for k,v in ipairs(p) do
        v:setFaction("Derelict")
        v:disable()
        v:rename("Shipwrecked " .. shipname)
    end

    
    evt.timerStart("broadcast", 3000)
   
    -- Set hooks
    hook.pilot(p[1], "board", "rescue")
    hook.time("endevent")
    hook.pilot(p[1], "death", "endevent")
end

function broadcast()
    -- Ship broadcasts an SOS every 10 seconds, until boarded or destroyed.
    p[1]:broadcast(string.format(broadcastmsg, shipname), true)
    bctimer = evt.timerStart("broadcast", 10000)
end

function rescue()
    -- Player boards the shipwreck and rescues the crew, this spawns a new mission.
    evt.timerStop(bctimer)
    evt.misnStart("The Space Family")
    evt.finish()
end

function endevent()
    -- The player has landed or jumped away, or killed the shipwreck. Destroy the event.
    evt.finish()
end