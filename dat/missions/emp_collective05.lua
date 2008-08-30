--[[

   Operation Black Trinity

   Sixth mission in the collective mini campaign.

   Notable campaign changes:
      * Keer takes over command superseding Dimitri.
      * First real combat begins.
      * Most of the plot is unrevealed.

   Mission Objectives:
      * Attempt to arrest Zakred.
      * Kill Zakred.

   Mission Stages:
      1) Get to the Trinity
      2) Trinity Combat
      3) Trinity dead/run

   Not too happy with the text (it chews it all up for you), but then again,
    I'm no writer.  Hopefully someone can clean it up a bit someday.

]]--

lang = naev.lang()
if lang == "es" then
   -- not translated atm
else -- default english
   misn_title = "Operation Black Trinity"
   misn_reward = "None"
   misn_desc = {}
   misn_desc[1] = "Arrest the ESS Trinity in %s."
   misn_desc[2] = "Return to base at %s in %s."
   title = {}
   title[1] = "Bar"
   title[2] = "Interrogation Room"
   title[3] = "Operation Black Trinity"
   title[4] = "Mission Accomplished"
   title[5] = "Mission Failure"
   text = {}
   text[1] = [[As you enter the bar you can't seem to see Sergeant Dimitri.  You look a bit around for him when you feel a heavy hand fall on your shoulder.  It seems like two armed soldiers are here to escort you somewhere, and from the looks of their weapons, they mean business.  You have no choice other then to comply.
They start leading you away from the bar through some hallways you've never been through.  Must be all those 'Authorized Personnel Only' signs and the armed guards that didn't make them too appealing.
Finally they toss you into what seems to be an interrogation room, telling you just to wait there.]]
   text[2] = [[After what seems to be a decaSTU you hear the door open.  You see a condecorated women walk in with two soldiers at the door.  She seems to be a Commodore from the insignia on her uniform.
"Hello, I'm Commodore Keer, I've taken over the Collective issue.  I have heard about your success in the previous missions and would like to offer you more continued work.  However furthur procedings must be kept in strict confidentiality for the interest of the Empire.  You willing to go all the way with this?"]]
   text[3] = [[You accept and she then dismisses both of the soldiers who proceed to wait outside.
"We've been following Sergeant Dimitri's progress since he started at %s.  The datapad you brought back has confirmed what we have suspected.  We have a undercover Collective agent somewhere in the military who's been feeding ex-Commodore Welsh data.  You don't understand right?  Let me explain."]]
   text[4] = [["The Collective was actually a project for the Empire, they were supposed to  be the ultimate weapon in flexibility and offense.  Commodore Welsh was in charge of the secret science facility on %s.  Shortly after the Incident we stopped hearing from the science facility.  We sent a recon and were met with hostile Collective drones.  It seems like the project had been a success, but the traitor Welsh went rogue.  Under normal circumstances we would have easily crushed the Collective, but after the incident these are hardly normal circumstances."
She goes on, "Things have gone out of hand.  We have had chances to crush Welsh, but he seems to always have evaded us and struck us where we were weakest.  We always knew there must have been another traitor in our midst, but with the datapad information we now know who he is."]]
   text[5] = [[She now clears her throat, "This operation has been dubbed 'Operation Black Trinity'.  We have reason to believe that the ESS Trinity has been operating with the traitor Welsh.  The ESS Trinity is commanded by Captain Zakred.  You will form part of a assault team with primary objective of arresting Zakred.  If all goes to worse, you are ordered to kill Zakred.  He must not escape."
"We'll be sending you with a small force.  You just stick around and if any trouble arises, take the ESS Trinity down.  Zakred is currently doing some maneuver exercises in %s.  You will have to find him there.  The other ships will follow your lead to %s.  Good luck."]]
   text[6] = [[You see Commodore Keer with a dozen soldiers waiting for you outside the landing pad.
"Congratulations on the success %s.  We never really expected to take Zakred alive.  Good riddance.  The next step is to begin an all out attack on Collective territory.  Meet up in the bar when you're ready.  We'll need all available pilots."]]
   text[7] = [[You see Commodore Keer with a dozen soldiers waiting for you outside the landing pad.
"You weren't supposed to let the Trinity get away!  Now we have no cards to play, we must wait for the Collective response or new information before being able to continue.  We'll notify you if we have somthing you can do for us, but for now we just wait."]]
   -- Conversation between pilots
   talk = {}
   talk[1] = "ESS Trinity:  Please turn off your engines and prepare to be boarded."
   talk[2] = "You will never talk me alive!"
   talk[3] = "Very well then.  All units engage ESS Trinity."
   talk[4] = "Incoming collective drones detected."
   talk[5] = "Mission Success: Return to base."
   talk[6] = "Mission Failure: Return to base."
end


-- Creates the mission
function create ()

   tk.msg( title[1], text[1] )

   -- Intro text
   if tk.yesno( title[2], text[2] )
      then
      misn.accept()

      -- Mission data
      misn_stage = 0
      misn_base, misn_base_sys = space.getPlanet("Omega Station")
      misn_target_sys = space.getSystem("NGC-7690")
      misn.setMarker(misn_target_sys)

      -- Mission details
      misn.setTitle(misn_title)
      misn.setReward( misn_reward )
      misn.setDesc( string.format(misn_desc[1], misn_target_sys:name() ))
      tk.msg( title[2], string.format(text[3], misn_base:name() ) )
      tk.msg( title[3], string.format(text[4], "Eiroik"))
      tk.msg( title[4], string.format(text[5], misn_target_sys:name(), misn_target_sys:name() ) )

      -- Escorts
      esc_pacifier = true
      esc_lancelot1 = true
      esc_lancelot2 = true

      hook.enter("jump")
      hook.land("land")
   end
end

-- Handles jumping to target system
function jump ()
   -- Only done for stage 1
   if misn_stage == 0 then
      local sys = space.getSystem()

      -- Escorts enter a while back
      enter_vect = player.pos()
      if enter_vect:dist() < 1000 then -- assume landed
         add_escorts()
      else -- Just jumped
         misn.timerStart( "add_escorts", rnd.int(2000, 5000) )
      end

      -- Create some havoc
      if sys == misn_target_sys then
         -- Disable spawning and clear pilots -> makes it more epic
         pilot.clear()
         pilot.toggleSpawn(false)

         misn_stage = 1

         -- Position trinity on the other side of the player
         v = player.pos()
         x, y = v:get()
         v:set( -x, -y )
         trinity = pilot.add("Trinity", "noidle", v)
         for k,v in pairs(trinity) do
            hook.pilot( k, "death", "trinity_kill" )
            hook.pilot( k, "jump", "trinity_jump" )
         end

         final_fight = 0
         misn.timerStart( "talk", rnd.int(6000, 8000) ) -- Escorts should be in system by now
      end

   -- Player ran away from combat - big disgrace.
   elseif misn_stage == 1 then

      player.msg( talk[6] )
   end
end


-- Gets the empire talker
function emp_talker ()
   if esc_pacifier then
      talker = paci
   elseif esc_lancelot1 then
      talker = lance1
   elseif esc_lancelot2 then
      talker = lance2
   else
      -- I don't like the idea of player talking, but we need the conversation
      talker = player.getPilot()
   end

   return talker
end


-- Little talk when ESS Trinity is encountered.
function talk ()
   -- Empire talks about arresting
   if final_fight == 0 then
      talker = emp_talker()
      talker:broadcast( talk[1] )

      final_fight = 1
      misn.timerStart( "talk", rnd.int( 3000, 4000 ))
   elseif final_fight == 1 then
      talker = trinity
      talker:broadcast( talk[2] )

      final_fight = 2
      misn.timerStart( "talk", rnd.int( 3000, 4000 ))
   elseif final_fight == 2 then
      -- Talk
      talker = emp_talker()
      talker:broadcast( talk[3] )

      -- ESS Trinity becomes collective now.
      trinity:setFaction("Collective")

      final_fight = 3
      misn.timerStart( "talk", rnd.int( 4000, 5000 ))
   elseif final_fight == 3 then
      player.msg( talk[4] )
      misn.timerStart( "call_drones", rnd.int( 3000, 5000 ) )
   end
end


-- Calls help for the ESS Trinity.
function call_drones ()
   pilot.add("Collective Sml Swarm")
end


-- Adds escorts that weren't killed sometime.
function add_escorts ()
   if esc_pacifier then
      enter_vect:add( rnd.int(-50,50), rnd.int(-50,50) )
      paci = pilot.add("Empire Pacifier", "escort_player", enter_vect)
      for k,v in pairs(paci) do
         hook.pilot(v, "death", "paci_dead")
      end
   end
   if esc_lancelot1 then
      enter_vect:add( rnd.int(-50,50), rnd.int(-50,50) )
      lance1 = pilot.add("Empire Lancelot", "escort_player", enter_vect)
      for k,v in pairs(lance1) do
         hook.pilot(v, "death", "lance1_dead")
      end
   end
   if esc_lancelot2 then
      enter_vect:add( rnd.int(-50,50), rnd.int(-50,50) )
      lance2 = pilot.add("Empire Lancelot", "escort_player", enter_vect)
      for k,v in pairs(lance2) do
         hook.pilot(v, "death", "lance2_dead")
      end
   end
end


-- Escort death functions -> will stop spawning
function paci_dead () esc_pacifier = false end
function lance1_dead () esc_lancelot1 = false end
function lance2_dead () esc_lancelot2 = false end


-- Handles arrival back to base
function land ()
   local planet = space.getPlanet()

   -- Just landing
   if misn_stage == 2 and planet == misn_base then

      if trinity_alive then
         -- Failure to kill
         tk.msg( title[5], text[7] )
         var.push("trinity", true)

         -- Rewards
         player.modFaction("Empire",-5)
      else
         -- Successfully killed
         tk.msg( title[4], string.format(text[6], player.name()) )
         var.push("trinity", false)

         -- Rewards
         player.modFaction("Empire",5)
      end

      misn.finish(true)
   end
end


-- Trinity hooks
function trinity_kill () -- Got killed
   player.msg( talk[5] )
   misn_stage = 2
   trinity_alive = false
   misn.setDesc( string.format(misn_desc[2], misn_base:name(), misn_base_sys:name() ))
end
function trinity_jump () -- Got away
   player.msg( talk[6] )
   misn_stage = 2
   trinity_alive = true
   misn.setDesc( string.format(misn_desc[2], misn_base:name(), misn_base_sys:name() ))
end
