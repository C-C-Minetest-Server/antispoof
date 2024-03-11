-- antispoof/src/normalize.lua
-- Handle normalization of usernames
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

-- Change this value every time the table below updates,
-- or the implentation of _as.normalize changes.
_as.flattern_map_ver = "1"

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

    ["_"] = "-",

    ["V"] = "U",
}

function _as.normalize(name)
    name = string.upper(name)
    for src, dst in pairs(_as.flattern_map) do
        name = string.gsub(name, src, dst)
    end
    return name
end