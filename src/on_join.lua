-- antispoof/src/on_join.lua
-- Handle player join
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
local logger = _int.logger:sublogger("on_join")

local function format_list_accounts(list)
    local rlst = {}
    for name, _ in pairs(list) do
        rlst[#rlst+1] = name
    end
    return table.concat(rlst, ", ")
end

minetest.register_on_prejoinplayer(function(name)
    if name == "singleplayer" or name == minetest.settings:get("name") then return end
    local auth = minetest.get_auth_handler()
    if not auth.get_auth(name) then
        local accounts = _as.check_username(name)
        if accounts then
            logger:action(("Rejected %s because similar username found"):format(name))
            return ("The name %s is too similar to the following existing account(s): %s"):format(
                name, format_list_accounts(accounts)
            )
        end
    end
end)

minetest.register_on_newplayer(function(player)
    local name = player:get_player_name()
    _as.add_username(name)
end)
