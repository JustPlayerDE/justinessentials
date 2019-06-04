local CATEGORY_NAME = "JustinE"
JUR = JUR or {}
JUR.BlockedUsers = JUR.BlockedUsers or {}
JUR.MessageTimeouts = JUR.MessageTimeouts or {}

function JUR.CheckUser(ply, type)
    local SteamID = ply:SteamID()

    if not JUR.BlockedUsers[SteamID] then
        JUR.BlockedUsers[SteamID] = {}
    end

    return JUR.BlockedUsers[SteamID][type] or false
end

function JUR.BlockUser(ply, type)
    local SteamID = ply:SteamID()
    JUR.BlockedUsers[SteamID][type] = not JUR.CheckUser(ply, type)

    return JUR.CheckUser(ply, type)
end

--[[
    Prevention Stuff
]]
function JUR.PreventSwep(ply)
    if JUR.CheckUser(ply, "sweps") then
        if (JUR.MessageTimeouts[ply:SteamID()] and JUR.MessageTimeouts[ply:SteamID()].sweps or 0) < CurTime() then
            ULib.tsayError(ply, "You are not Allowed to use Weapons!", true)
            JUR.MessageTimeouts[ply:SteamID()] = JUR.MessageTimeouts[ply:SteamID()] or {}
            JUR.MessageTimeouts[ply:SteamID()].sweps = CurTime() + 5
        end

        return false
    end
end

function JUR.PreventSwepLoadout(ply)
    if JUR.CheckUser(ply, "sweps") then
        ULib.tsayError(ply, "Your weapons have been stripped from you because you are not allowed to have weapons.", true)
        ply:StripWeapons()

        return false
    end
end

function JUR.PreventEntity(ply)
    if JUR.CheckUser(ply, "entity") then
        if (JUR.MessageTimeouts[ply:SteamID()] and JUR.MessageTimeouts[ply:SteamID()].entity or 0) < CurTime() then
            ULib.tsayError(ply, "You are not Allowed to spawn any Entity!", true)
            JUR.MessageTimeouts[ply:SteamID()] = JUR.MessageTimeouts[ply:SteamID()] or {}
            JUR.MessageTimeouts[ply:SteamID()].entity = CurTime() + 5
        end

        return false
    end
end

function JUR.PreventVehicle(ply)
    if JUR.CheckUser(ply, "vehicle") then
        if (JUR.MessageTimeouts[ply:SteamID()] and JUR.MessageTimeouts[ply:SteamID()].vehicle or 0) < CurTime() then
            ULib.tsayError(ply, "You are not Allowed to drive any Vehicle!", true)
            JUR.MessageTimeouts[ply:SteamID()] = JUR.MessageTimeouts[ply:SteamID()] or {}
            JUR.MessageTimeouts[ply:SteamID()].vehicle = CurTime() + 5
        end

        return false
    end
end

function JUR.PreventTool(ply)
    if JUR.CheckUser(ply, "tool") then
        if (JUR.MessageTimeouts[ply:SteamID()] and JUR.MessageTimeouts[ply:SteamID()].tool or 0) < CurTime() then
            ULib.tsayError(ply, "You are not Allowed to use any Tool!", true)
            JUR.MessageTimeouts[ply:SteamID()] = JUR.MessageTimeouts[ply:SteamID()] or {}
            JUR.MessageTimeouts[ply:SteamID()].tool = CurTime() + 5
        end

        return false
    end
end

function JUR.DarkRPBuySWEP(ply)
    if JUR.CheckUser(ply, "sweps") then
        ULib.tsayError(ply, "You are not Allowed to buy any Weaponry.", true)

        return false
    end
end

function JUR.DarkRPBuySENT(ply)
    if JUR.CheckUser(ply, "entity") then
        ULib.tsayError(ply, "You are not Allowed to buy any Entity.", true)

        return false
    end
end

function JUR.DarkRPBuyVEHICLE(ply)
    if JUR.CheckUser(ply, "vehicle") then
        ULib.tsayError(ply, "You are not Allowed to buy any Vehicle.", true)

        return false
    end
end

--[[
    Hooks stuff
]]
-- DARKRP STUFF
hook.Add("canBuyShipment", "JUR.RestrictBuyPistol1", JUR.DarkRPBuySWEP, HOOK_LOW)
hook.Add("canBuyAmmo", "JUR.RestrictBuyPistol2", JUR.DarkRPBuySWEP, HOOK_LOW)
hook.Add("canBuyPistol", "JUR.RestrictBuyPistol3", JUR.DarkRPBuySWEP, HOOK_LOW)
hook.Add("canBuyCustomEntity", "JUR.RestrictBuyEntity", JUR.DarkRPBuySENT, HOOK_LOW)
hook.Add("canBuyVehicle", "JUR.RestrictBuyVehicle", JUR.DarkRPBuyVEHICLE, HOOK_LOW)
-- PROPS/ENTITES
hook.Add("PlayerSpawnEntity", "JUR.RestrictEntitySpawning1", JUR.PreventEntity, HOOK_LOW)
hook.Add("PlayerSpawnNPC", "JUR.RestrictEntitySpawning2", JUR.PreventEntity, HOOK_LOW)
hook.Add("PlayerSpawnEffect", "JUR.RestrictEntitySpawning3", JUR.PreventEntity, HOOK_LOW)
hook.Add("PlayerSpawnProp", "JUR.RestrictEntitySpawning4", JUR.PreventEntity, HOOK_LOW)
hook.Add("PlayerSpawnSENT", "JUR.RestrictEntitySpawning5", JUR.PreventEntity, HOOK_LOW)
hook.Add("PlayerSpawnRagdoll", "JUR.RestrictEntitySpawning6", JUR.PreventEntity, HOOK_LOW)
-- WEAPONS
hook.Add("PlayerSpawnSWEP", "JUR.RestrictSwepUse1", JUR.PreventSwep, HOOK_LOW)
hook.Add("PlayerGiveSWEP", "JUR.RestrictSwepUse2", JUR.PreventSwep, HOOK_LOW)
hook.Add("PlayerCanPickupWeapon", "JUR.RestrictSwepUse3", JUR.PreventSwep, HOOK_LOW)
hook.Add("PlayerLoadout", "JUR.RestrictSwepUse4", JUR.PreventSwepLoadout, HOOK_LOW)
-- VEHICLES
hook.Add("CanPlayerEnterVehicle", "JUR.RestrictVehicleUse", JUR.PreventVehicle, HOOK_LOW)
-- TOOLS
hook.Add("CanTool", "JUR.RestrictToolUse", JUR.PreventTool, HOOK_LOW)

--[[
    Commands stuff
]]
-------------------------- !sentsban --------------------------
function JUR.BanPropStuff(calling_ply, target_ply)
    if JUR.BlockUser(target_ply, "entity") then
        ulx.fancyLogAdmin(calling_ply, "#A banned #T from spawning props or entities", target_ply)
    else
        ulx.fancyLogAdmin(calling_ply, "#A unbanned #T from spawning props or entities", target_ply)
    end
end

local propsban = ulx.command(CATEGORY_NAME, "ulx sentsban", JUR.BanPropStuff, "!sentsban")

propsban:addParam{
    type = ULib.cmds.PlayerArg
}

propsban:defaultAccess(ULib.ACCESS_ADMIN)
propsban:help("Bans a Player from spawning any Prop or Entity")

-------------------------- !swepban --------------------------
function JUR.BanSwepStuff(calling_ply, target_ply)
    if JUR.BlockUser(target_ply, "sweps") then
        ulx.fancyLogAdmin(calling_ply, "#A banned #T from using sweps", target_ply)
        target_ply:StripWeapons()
    else
        ulx.fancyLogAdmin(calling_ply, "#A unbanned #T from using sweps", target_ply)
        hook.Run( "PlayerLoadout" , target_ply )
    end
end

local swepban = ulx.command(CATEGORY_NAME, "ulx swepban", JUR.BanSwepStuff, "!swepban")

swepban:addParam{
    type = ULib.cmds.PlayerArg
}

swepban:defaultAccess(ULib.ACCESS_ADMIN)
swepban:help("Bans a Player from using sweps")

-------------------------- !toolban --------------------------
function JUR.BanToolStuff(calling_ply, target_ply)
    if JUR.BlockUser(target_ply, "tool") then
        ulx.fancyLogAdmin(calling_ply, "#A banned #T from using tools", target_ply)
    else
        ulx.fancyLogAdmin(calling_ply, "#A unbanned #T from using tools", target_ply)
    end
end

local toolban = ulx.command(CATEGORY_NAME, "ulx toolban", JUR.BanToolStuff, "!toolban")

toolban:addParam{
    type = ULib.cmds.PlayerArg
}

toolban:defaultAccess(ULib.ACCESS_ADMIN)
toolban:help("Bans a Player from using tools")

-------------------------- !vehicleban --------------------------
function JUR.BanVehicleStuff(calling_ply, target_ply)
    if JUR.BlockUser(target_ply, "vehicle") then
        ulx.fancyLogAdmin(calling_ply, "#A banned #T from using vehicles", target_ply)
    else
        ulx.fancyLogAdmin(calling_ply, "#A unbanned #T from using vehicles", target_ply)
    end
end

local vehicleban = ulx.command(CATEGORY_NAME, "ulx vehicleban", JUR.BanVehicleStuff, "!vehicleban")

vehicleban:addParam{
    type = ULib.cmds.PlayerArg
}

vehicleban:defaultAccess(ULib.ACCESS_ADMIN)
vehicleban:help("Bans a Player from using vehicles")