SLASH_AAF1 = "/aaf"
local debug = false

local function DebugMessage(text)
    if debug then
        SendSystemMessage(text)
    end
end

local function FindHealer()
    for i=1,3 do
        local specId, gender = GetArenaOpponentSpec(i)
        DebugMessage(specId)
        local spec = GetSpecializationRoleByID(specId)
        DebugMessage(spec)
        if spec == "HEALER" then
            return i
        end
    end
    return 0
end

local function ReplaceMacro(arenaId)
    local macroName = "AAF"
    local focusMacroRegEx = "arena%d"
    local macroId = GetMacroIndexByName(macroName)
    if macroId > 0 then
        local body = GetMacroBody(macroId)
        DebugMessage(body)
        local replace = string.gsub(body, focusMacroRegEx, "arena"..arenaId)
        DebugMessage(replace)
        EditMacro(macroId, macroName, nil, replace)
    else
        SendSystemMessage("[AAF] Please create macro having /focus arena1 with name "..macroName)
    end
end

local function FindHealerHandler()
    if C_PvP.IsArena() then
        local arenaId = FindHealer()
        if arenaId > 0 then
            ReplaceMacro(arenaId)
            local name = UnitName("arena"..arenaId)
            SendSystemMessage("[AAF] Macro AAF focused: "..name.." - arena"..arenaId)
        end
    else
        SendSystemMessage("[AAF] Not inside arena !")
    end
end

SlashCmdList["AAF"] = FindHealerHandler