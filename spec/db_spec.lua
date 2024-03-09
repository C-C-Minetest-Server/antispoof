require "mineunit"
mineunit "core"
_G.antispoof = {
	spoofuser = {},
	internal = {
		logger = { -- no-op logger
			sublogger = function() end,
		},
		S = minetest.get_translator("antispoof"),
	}
}

sourcefile "src/db"

antispoof.add_username("1F616EMO_c")
describe("antispoof check", function()
	it("works", function()
		for _, name in ipairs {
			"1F616EM0_c",
			"IF616EMO_c",
			"lF616EMO_c",
			"1F616EMO_-_c",
		} do
			assert.is_truthy(antispoof.check_username(name))
		end
	end)
	it("should not give false positives", function()
		for _, name in pairs {
			"1F616EMO_s",
			"1F616EMO",
			"U_1F616EMO",
			"Sam",
		} do
			assert.is_falsy(antispoof.check_username(name))
		end
	end)
end)
