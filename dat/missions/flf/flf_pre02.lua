--[[
-- This is the second "prelude" mission leading to the FLF campaign.
-- stack variable flfbase_intro:
--      1 - The player has turned in the FLF agent or rescued the Dvaered crew. Conditional for dv_antiflf02
--      2 - The player has rescued the FLF agent. Conditional for flf_pre02
--      3 - The player has found the FLF base for the Dvaered, or has betrayed the FLF after rescuing the agent. Conditional for dv_antiflf03
--]]

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
    title = {}
    text = {}
    DVtitle = {}
    DVtext = {}
    osd_desc = {}
    FLFosd = {}
    DVosd = {}
    
    introfirst = [[    The FLF officer doesn't seem at all surprised that you approached him. On the contrary, he looks like he expected you to do so all along.
    "Greetings," he says, nodding at you in curt greeting. "I am Corporal Benito. And you are %s, the guy who got Lt. Fletcher back here in one piece. Oh yes, I know all about that. It's not a secret, after all. Besides, you can't keep anything a secret for long on a station like this in the first place." Benito's expression becomes a little more severe. "I'm not here to exhange pleasantries, however. You probably noticed, but people here are a little uneasy about your presence. They don't know what to make of you, see. You helped us once, it is true, but that doesn't tell us much. We don't know you."
    ]]
    
    introrepeat = [[    "Hello again, %s" Corporal Benito says to you. "I see you've come back, though I can't imagine you're here to meet up with any friends."
    ]]
    
    title[1] = "A chance to prove yourself"
    text[1] = [[Indeed, you are constantly aware of the furtive glances the other people in this bar are giving you. They don't seem outright hostile, but you can tell that if you don't watch your step and choose your words carefully, things might quickly take a turn for the worse.
    Benito waves his hand to indicate you needn't pay them any heed. "That said, the upper ranks have decided that if you are truly sympathetic to our cause, you will be given an opportunity to prove yourself. Of course, if you'd rather not get involved in our struggle, that's understandable. But if you're in for greater things, if you stand for justice... Perhaps you'll consider joining with us?"]]
    
    title[2] = "Patrol-B-gone"
    text[2] = [[    "I'm happy to hear that. It's good to know we still have the support from the common man. Anyway, let me fill you in on what it is we want you to do. As you may be aware, the Dvaered have committed a lot of resources to finding us and flushing us out lately. And while our base is well hidden, those constant patrols are certainly not doing anything to make us feel more secure! I think you can see where this is going. You will have to go out there and make it so the Dvaered don't patrol anymore."
    You object, asking the Corporal if all recruits have to undertake dangerous missions like this to be accepted into the FLF ranks. Benito chuckles, and makes a pacifying gesture.
    "Calm down, it's not as bad as it sounds. You won't be out there alone. We're sending along a wing of experienced fighters, so you're not on your own. We really want those patrols gone, you know. We're just testing your loyalty at the same time, that's all. Now, I should warn you. In line with most of our tactics, this mission will be a surgical strike, hit-and-run operation. That means we work with small, fast ships. We go in, get the job done and disappear. This time will be no different."]]
    
    title[3] = "You need to change ships"
    text[3] = [[    "Unfortunately, your current ship isn't suitable for that purpose. You will need to change to either a Yacht, Scout, Bomber or Fighter class ship. Come talk to me again once you've done so."]]
    
    title[4] = ""
    text[4] = [[    "I've seen your ship, and I think you'll have no problem carrying out the mission with it. However, make sure you don't switch to anything larger, because if you do we'll have to consider the op a failure and abort.
    "Our contacts report three Dvaered patrols are in service at the moment. You will have to tackle them one by one. Your map will tell you where to go. Good luck, %s. Shoot down a Dvaered for me."]]
    
    title[5] = "Breaking the ice"
    text[5] = [[    When you left Sindbad station, it was a cold, lonely place for you. The FLF soldiers on the station avoided you whenever they could, and basic services were harder to get than they should have been. 
    But now that you have returned victorious over the Dvaered, the place has become considerably more hospitable. There are more smiles on people's faces, and some even tell you you did a fine job. Among them is Corporal Benito. He walks up to you and offers you his hand.
    "Welcome back, %s, and congratulations. We already know all about your success in battle against the Dvaered patrols. And before you ask, no, I didn't know they were going to field a Vigilance. I might not have sent you out there if I did. But then, you're still in one piece, so maybe I shouldn't worry so much, eh?"
    Benito takes you to the station's bar, and buys you what for lack of a better word must be called a drink.
    "We will of course reward you for your service," he says once you are seated. "Though you must understand the FLF don't have that big a budget. Financial support is tricky, and the Frontier don't have that much to spare themselves to begin with. Nevertheless, we are willing to pay for good work, and your work is nothing but. What's more, you've ingratiated yourself with many of us, as you've undoubtedly noticed. Our top brass is among those you've impressed, you from today on, you can call yourself one of us! How about that, huh?"]]
    
    text[6] = [[    "Of course, our work is only just beginning. You got those patrols off our backs, but they'll eventually return. No rest for the weary, we must continue the fight against the oppressors. I'm sure the road is still long, but I'm encouraged by the fact that we gained another valuable ally today. I'm sure you'll play an imporant role in our eventual victory over the Dvaered!"
    That last part earns a cheer from the assembled FLF soldiers. You decide to raise your glass with them, making a toast to the fortune of battle in the upcoming campaign - and the sweet victory that lies beyond.]]
    
    refusetitle = "Some other time perhaps"
    refusetext = [[    "I see. That's a fair answer, I'm sure you have your reasons. But if you ever change your mind, I'll be around on Sindbad. You won't have trouble finding me, I'm sure."]]

    failtitle = "Your ship is invalid!"
    failtext = [[You have switched to a ship that's not suitable for this mission. FLF Command has pulled the plug on this operation, your mission has failed.]]

    DVtitle[1] = "A tempting offer"
    DVtext[1] = [[    "Citizen!"
    Your viewscreen shows a Dvaered Colonel. He looks tense. Normally, a tense Dvaered would be bad news, but then this one bothered to hail you in the heat of battle, so perhaps there is more here than meets the eye.
    "I am Colonel Urnus of the Dvaered Fleet, anti-terrorism division. I would normally never contact an enemy of House Dvaered, but my intelligence officer has identified you as a former Dvaered employee based on your ship and our ship registration database. According to our records, you have previously worked in my division, taking freelance security patrol assignments, and completing them successfully."
    You make a noncommital response. Just because you've flown missions for the Dvaered doesn't mean they're your friends. However, the ship Colonel is persistent.
    "I know your type, citizen. You take jobs where profit is to be had, and you side with the highest bidder. There are many like you in the galaxy, though admittedly not so many with your talent. That's why I'm willing to make you this offer: you will side with our ships and engage the terrorist fighters. Then you will provide us with information on their base of operations and their combat strength. In return, I will convince my superiors that you were working for me all along, so you won't face any repercussions for assaulting Dvaered ships. Furthermore, I will transfer a considerable amount of credits in your account, as well as put you into a position to make an ally out of House Dvaered. If you refuse, however, I guarantee you that you will never again be safe in Dvaered space. What say you? Surely this proposition beats anything those rabble can do for you?"]]
    
    DVchoice1 = "Accept the offer"
    DVchoice2 = "Remain loyal to the FLF"
    
    DVtitle[2] = "Opportunism is an art"
    DVtext[2] = [[    Colonel Urnus smiles broadly. "I knew you'd make the right choice, citizen!" He addresses someone on his bridge, out of the view of the camera. "Notify the flight group. %s %s is now a friendly. Engage the other hostiles!" Then he turns back to you. "Proceed to %s in the %s system after this battle, citizen. I will personally meet you there."
    Urnus breaks the connection, and you go back to winning this battle - albeit for the other side this time.]]
    
    DVtitle[3] = "End of negotiations"
    DVtext[3] = [[    Colonel Urnus is visibly annoyed by your repsonse. "Very well then," he bites at you. "In that case you will be destroyed along with the rest of that terrorist scum. Helm, full speed ahead! All batteries, fire at will!"]]
    
    DVtitle[4] = "A reward for a job well botched"
    DVtext[4] = [[    Soon after docking, you are picked up by a couple of soldiers, who escort you to Colonel Urnus' office. Urnus greets you warmly, and offers you a seat and a cigar. You take the former, not the latter.
    "I am most pleased with the outcome of this situation, citizen," Urnus begins. "To be absolutely frank with you, I was beginning to get frustrated. My superiors have been breathing down my neck, demanding results on those blasted FLF, but they are as slippery as eels. Just when you think you've cornered them, poof! They're gone, lost in that nebula. Thick as soup, that thing. I don't know how they can even find their own way home!"
    Urnus takes a puff of his cigar and blows out a ring of smoke. It doesn't take a genius to figure out you're the best thing that's happened to him in a long time.
    "Anyway. I promised you money, status and opportunities, and I intend to make good on those promises. Your money is already in your account. Check your balance sheet later. As for status, I can assure you that no Dvaered will find out what you've been up to. As far as the military machine is concerned, you have nothing to do with the FLF. In fact, you're known as an important ally in the fight against them! Finally, opportunities. We're analyzing the data from your flight recorder as we speak, and you'll be asked a few questions after we're done here. Based on that, we can form a new strategy against the FLF. Unless I miss my guess by a long shot, we'll be moving against them in force very soon, and I will make sure you'll be given the chance to be part of that. I'm sure it'll be worth your while."]]
    DVtext[5] = [[    Urnus stands up, a sign that this meeting is drawing to a close. "Keep your eyes open for one of our liaisons, citizen. He'll be your ticket into the upcoming battle. Now, I'm a busy man so I'm going to have to ask you to leave. But I hope we'll meet again, and if you continue to build your career like you have today, I'm sure we will. Good day to you!"
    You leave the Colonel's office. You are then taken to an interrogation room, where Dvaered petty officers question you politely yet persistently about your brief stay with the FLF. Once their curiosity is satisfied, they let you go, and you are free to return to your ship.]]
    
    failtitle = "All your wingmen are dead!"
    failtext = [[You receive a coded transmission from FLF command. It reads, "It seems your wing has been wiped out. It's too dangerous to let you continue the mission alone. Abort the operation and return to base."]]
    
    flfcomm = "%s has sold us out! Break and attack!"
    
    misn_title = "Disrupt the Dvaered Patrols"
    misn_desc = "To prove yourself to the FLF, you must lead a wing of fighters into Dvaered space and take out their security patrols. Note that you must do this mission in a Fighter, Scout or Yacht class ship."
    misn_rwrd = "A chance to make friends out of the FLF."
    osd_desc[1] = ""
    osd_desc[2] = "Wait for the Dvaered patrol to arrive and engage"
    FLFosd[1] = "Fly to the %s system"
    FLFosd[2] = "Return to the FLF base"
    DVosd[1] = "Destroy your wingmen!"
    DVosd[2] = "Fly to the %s system and land on %s"
        
    npc_desc = "There is a low-ranking officer of the Frontier Liberation Front sitting at one at the tables. He seems somewhat more receptive than most people in the bar."
    
end

function create()
    misn.setNPC("FLF petty officer", "flf_officer1")
    misn.setDesc(npc_desc)
end

function accept()
    -- Check if this is the first time talking to the mission NPC
    if var.peek("flfoffer") then
        txt = string.format(introrepeat, player.name()) .. text[1]
    else
        txt = string.format(introfirst, player.name()) .. text[1]
    end

    pclass = player.pilot():ship():class()
    if tk.yesno(title[1], txt) then
        if pclass == "Yacht" or pclass == "Fighter" or pclass == "Scout" or pclass == "Bomber" then
            misn.accept()

            var.pop("flfoffer")
            encounters = 1

            sysname = {"Zacron", "Torg", "Klantar"}
            sysname["__save"] = true

            tk.msg(title[2], text[2])
            tk.msg(title[2], string.format(text[4], player.name()))

            osd_desc[1] = string.format(FLFosd[1], sysname[encounters])
            misn.osdCreate(misn_title, osd_desc)
            misn.setDesc(misn_desc)
            misn.setTitle(misn_title)
            misn.setMarker(system.get(sysname[encounters]), "misc")
            misn.setReward(misn_rwrd)
            
            escarmor = {100, 100, 100, 100}
            escshield = {100, 100, 100, 100}
            escarmor["__save"] = true
            escshield["__save"] = true

            DVplanet = "Stalwart Station"
            DVsys = "Darkstone"
            
            loyalFLF = true
            retreat = true
            alldead = false
            hailed = false
            
            DVstanding = faction.get("Dvaered"):playerStanding()

            hook.land("land")            
            hook.jumpin("jumpin")
            hook.jumpout("jumpout")
            hook.takeoff("takeoff")
        else
            tk.msg(title[2], text[2])
            tk.msg(title[3], text[3])
            var.push("flfoffer", true)
            misn.finish()
        end
    else
        tk.msg(refusetitle, refusetext)
        var.push("flfoffer", true)
        misn.finish()
    end
end

function land()
    if spawnie ~= nil then
        misn.timerStop(spawnie)
    end
    if hailie ~= nil then
        misn.timerStop(hailie)
    end
    
    if planet.cur():name() == "Sindbad" and encounters == 4 then
        tk.msg(title[5], string.format(text[5], player.name()))
        tk.msg(title[5], text[6])
        player.pay(100000) -- 100K
        var.pop("flfbase_sysname")
        var.pop("flfbase_intro")
        misn.finish(true)
    elseif planet.cur():name() == DVplanet and DVwin then
        tk.msg(DVtitle[4], DVtext[4])
        tk.msg(DVtitle[4], DVtext[5])
        player.pay(70000) -- 70K
        var.push("flfbase_intro", 3)
        if diff.isApplied("FLF_base") then
            diff.remove("FLF_base")
        end
        misn.finish(true)
    end
end

function takeoff()
    DVdeaths = 0

    -- Check if the player is still in a valid craft
    pclass = player.pilot():ship():class()
    if loyalFLF and pclass ~= "Yacht" and pclass ~= "Fighter"  and pclass ~= "Scout" and pclass ~= "Bomber" then
        tk.msg(failtitle, failtext)
        abort()
    end

    -- Add the FLF wing, no need to keep track of health since it's a takeoff situation (other than death, obviously)
    fleetFLF = pilot.add("Independent Vendetta Quartet", string.format("escort*%u", player.pilot():id()), player.pos(), false)
    for i, j in ipairs (fleetFLF) do
        if escarmor[i] > 0 then
            j:rename("FLF Wingman")
            j:setFriendly()
            j:setNodisable(true)
            hook.pilot(j, "death", "FLFdeath")
            if not loyalFLF then
                j:setFaction("FLF")
            end
        else
            j:rm()
        end
    end
    
    checkPatrol()
end

function jumpin()
    -- Reset Dvaered kill count, OSD
    DVdeaths = 0
    misn.osdActive(1)
    
    if alldead and retreat and loyalFLF then
        tk.msg(failtitle, failtext)
        misn.finish(false) -- The player can accept the mission again, so don't abort().
    else
        misn.timerStart("spawnFLF", 2000)
    end

    checkPatrol()
end

function jumpout()
    if spawnie ~= nil then
        misn.timerStop(spawnie)
    end
    if hailie ~= nil then
        misn.timerStop(hailie)
    end
    for i, j in ipairs (fleetFLF) do
        if j:exists() then
            escarmor[i], escshield[i] = j:getHealth()
        end
    end
end

-- Handles the conditionals prior to Dvaered patrol spawn
function checkPatrol()
    -- In the designated systems, encounter the FLF. Third encounter is special.
    if encounters < 4 and system.cur():name() == sysname[encounters] then
        misn.osdActive(2)
        pilot.clear()
        pilot.toggleSpawn(false)
        
        if encounters < 3 then
            spawnie = misn.timerStart("spawnSmallDV", 12000)
        else
            spawnie = misn.timerStart("spawnBigDV", 12000)
            dv_patrol = var.peek("dv_patrol")
            if dv_patrol ~= nil then
                if var.peek("dv_patrol") >= 3 then
                    hailie = misn.timerStart("hailEvent", 20000)
                end
            end
        end
    end
end

-- Handles the hailing event
-- TODO: Retool this for the new comm system once it's implemented.
function hailEvent()
    -- osd_desc[1] = string.format("Take out your FLF wingmen and report to %s (%s system)", DVplanet, DVsys)
    -- TODO: Hailing event
    for i, j in ipairs(fleetDV) do
        if j:ship():class() == "Destroyer" then
            j:hailPlayer()
            hook.pilot(j, "hail", "hail")
        end
    end
end

-- The actual hailing event
function hail()
    local winAlive = false
    
    if not hailed then
        choice = tk.choice(DVtitle[1], DVtext[1], DVchoice1, DVchoice2)
        if choice == 1 then
            tk.msg(DVtitle[2], string.format(DVtext[2], player.pilot():ship():class(), player.ship(), DVplanet, DVsys))
            
            -- Set the FLF to super hostile, set Dvaered opinion to 0 if it was negative
            faction.get("FLF"):modPlayerRaw(-200)
            standing = faction.get("Dvaered"):playerStanding()
            if standing < 0 then
                faction.get("Dvaered"):modPlayerRaw(-standing)
            end
            
            -- Switch sides, reset AIs
            loyalFLF = false
            for i, j in ipairs(fleetDV) do
                if j:exists() then
                    j:setFriendly()
                    j:changeAI("dvaered_nojump")
                    if j:ship():class() == "Destroyer" then
                        j:setInvincible(true) -- You're not going to lose at this point anyway, and Urnus shouldn't die, we still need him.
                    end
                end
            end
            for i, j in ipairs(fleetFLF) do
                if j:exists() then
                    wingAlive = true
                    j:setHostile()
                    j:control()
                    j:attack(player.pilot())
                end
            end
            
            if wingAlive then
                misn.timerStart("commFLF", 3000)
                
                osd_desc[1] = DVosd[1]
                osd_desc[2] = nil
                misn.osdActive(1)
                misn.osdCreate(misn_title, osd_desc)
    
                retreat = false
            else
                DVwin = true
                osd_desc[1] = string.format(DVosd[2], DVsys, DVplanet)
                osd_desc[2] = nil
                misn.osdActive(1)
                misn.osdCreate(misn_title, osd_desc)
                misn.setMarker(system.get(DVsys), "misc")
                
                for i, j in ipairs(fleetDV) do
                    if j:exists() then
                        j:changeAI("flee")
                    end
                end
            end
        else
            tk.msg(DVtitle[3], DVtext[3])
        end
    end
    hailed = true
end

-- Spawns the FLF wingmen when the player jumps into a new system.
function spawnFLF()
    -- Add the FLF wing, keep track of their health
    fleetFLF = pilot.add("Independent Vendetta Quartet", string.format("escort*%u", player.pilot():id()), player.pos(), true)
    for i, j in ipairs (fleetFLF) do
        if escarmor[i] > 0 then
            j:setHealth(escarmor[i], escshield[i])
            j:rename("FLF Wingman")
            j:setNodisable(true) -- So it doesn't look weird when disabled wingmen show up later
            hook.pilot(j, "death", "FLFdeath")
            if not loyalFLF then
                j:setFaction("FLF")
                j:control()
                j:attack(player.pilot())
            else
                j:setFriendly()
            end
        else
            j:rm()
        end
    end
end

function commFLF()
    for i, j in ipairs (fleetFLF) do
        if j:exists() then
            j:broadcast(string.format(flfcomm, player.name()), true)
            break
        end
    end
end

-- Spawns a small Dvaered patrol
function spawnSmallDV()
    fleetDV = pilot.add("Dvaered Small Patrol", "dvaered_nojump", player.pos(), true)
    for i, j in ipairs(fleetDV) do
        j:rename(string.format("Dvaered Patrol %s", j:ship():class()))
        hook.pilot(j, "death", "DVdeath")
        j:setHostile()
    end
    for i, j in ipairs (fleetFLF) do
        if j:exists() then
            j:setFaction("FLF")
            j:changeAI("flf_nojump")
        end
    end
end

-- Spawns a big Dvaered patrol
function spawnBigDV()
    fleetDV = pilot.add("Dvaered Big Patrol", "dvaered_nojump", player.pos(), true)
    for i, j in ipairs(fleetDV) do
        if j:ship():class() == "Destroyer" then -- It's a mini-boss of sorts, but it should still be dumbed down.
            j:rmOutfit("all")
            j:addOutfit("Plasma Blaster MK2", 2)
            j:addOutfit("Shield Booster", 1)
            j:addOutfit("Steering Thrusters", 1)
            j:addOutfit("Shield Capacitor III", 1)
            j:addOutfit("Forward Shock Absorbers", 1)
            j:addOutfit("Reactor Class I", 1)
            j:rename("Dvaered Patrol Leader")
            j:setNodisable(true) -- Avoid trouble
        else
            j:rename(string.format("Dvaered Patrol %s", j:ship():class()))
        end
        j:setHostile()
        hook.pilot(j, "death", "DVdeath")
    end
    for i, j in ipairs (fleetFLF) do
        if j:exists() then
            j:setFaction("FLF")
            j:changeAI("flf_nojump")
        end
    end
end

-- Keeps track of the player score
function DVdeath()
    -- Reset standing with the Dvaered
    standing = faction.get("Dvaered"):playerStanding()
    faction.get("Dvaered"):modPlayerRaw(-standing)
    faction.get("Dvaered"):modPlayerRaw(DVstanding)

    DVdeaths = DVdeaths + 1
    if DVdeaths == #fleetDV then
        encounters = encounters + 1
        if encounters == 4 then
            osd_desc[1] = FLFosd[2]
            osd_desc[2] = nil
            misn.osdActive(1)
            misn.osdCreate(misn_title, osd_desc)
            misn.setMarker(system.get(var.peek("flfbase_sysname")), "misc")
            retreat = false
        else
            osd_desc[1] = string.format(FLFosd[1], sysname[encounters])
            misn.osdCreate(misn_title, osd_desc)
            misn.osdActive(1)
            misn.setMarker(system.get(sysname[encounters]), "misc")
            retreat = true
        end
        -- Patrol clear.
    end
end

-- Hook for wingman death. If the wing is wiped out, either the player is recalled to the FLF base, or he wins the mission if he betrayed the FLF.
function FLFdeath()
    alldead = true
    for i, j in ipairs(fleetFLF) do
        if j:exists() then
            alldead = false
        else
            escarmor[i] = 0
            escshield[i] = 0
        end
    end
    
    if alldead then
        if not loyalFLF then
            DVwin = true
            osd_desc[1] = string.format(DVosd[2], DVsys, DVplanet)
            osd_desc[2] = nil
            misn.osdActive(1)
            misn.osdCreate(misn_title, osd_desc)
            misn.setMarker(system.get(DVsys), "misc")
            
            for i, j in ipairs(fleetDV) do
                if j:exists() then
                    j:changeAI("flee")
                end
            end
        end
    end
end

function abort()
    var.pop("flfbase_sysname")
    var.pop("flfbase_intro")
    misn.finish(false)
end
