-- antispoof/src/db.lua
-- Handle spoofuser database
--[[
    AntiSpoof: Preventing confusable usernames
    Copyright (C) 2024  1F616EMO

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]

local _as = antispoof
local _int = _as.internal
local logger = _int.logger:sublogger("db")

local S = _int.S

-- minetest/src/player.h
-- #define PLAYERNAME_ALLOWED_CHARS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"

-- Usernames are all first converted to uppercase
-- Therefore, the sources and destinations should be uppercase.
_as.flattern_map = {
    ["0"] = "O",
    ["Q"] = "O",
    ["9"] = "O", -- 9 -> Q -> O

    ["1"] = "I",
    ["L"] = "I",

    ["2"] = "Z",

    ["5"] = "S",

    ["[_%-]+"] = "-",

    ["V"] = "U",
}

function _as.normalize(name)
    name = string.upper(name)
    for src, dst in pairs(_as.flattern_map) do
        name = string.gsub(name, src, dst)
    end
    return name
end

-- Check if the username is inside the table
-- i.e. not avaliable
function _as.check_username(name)
    local nname = _as.normalize(name)
    return _as.spoofuser[nname]
end

function _as.add_username(name)
    local nname = _as.normalize(name)
    _as.spoofuser[nname] = _as.spoofuser[nname] or {}
    _as.spoofuser[nname][name] = true
end

-- Must be called after load time
function _as.prepare_db()
    _as.spoofuser = {}
    local auth = minetest.get_auth_handler()
    for name in auth.iterate() do
        _as.add_username(name)
    end
    logger:action("Database updated")
end

minetest.register_chatcommand("as_db_init", {
    description = S("Prepare the AntiSpoof database"),
    privs = { server = true },
    func = function()
        _as.prepare_db()
        return true, S("Database updated.")
    end,
})
