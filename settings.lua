
data:extend({ 	

	-- runtime global
   {
		type = "string-setting",
		name = "floating-damage-string-format",
		setting_type = "runtime-global",
		default_value = "%s",
		allow_blank = true,
		order = "da-[format]",
	},
	{
		type = "int-setting",
		name = "floating-number-rounding",
		setting_type = "runtime-global",
		default_value = 2,
		minimum_value = -6,
		maximum_value = 6,
		order = "da-[rounding]",		
	},
	{
		type = "string-setting",
		name = "floating-ally-damage-color",
		setting_type = "runtime-global",
		default_value = "255,127,0",
		order = "db-[color-ally]",
	},
	{
		type = "string-setting",
		name = "floating-enemy-damage-color",
		setting_type = "runtime-global",
		default_value = "200,0,0",
		order = "db-[color-enemy]",
	},
	{
		type = "string-setting",
		name = "floating-neutral-damage-color",
		setting_type = "runtime-global",
		default_value = "200,200,200",
		order = "db-[color-neutral]",
	},
	--[[
	{
		type = "string-setting",
		name = "floating-healing-color",
		setting_type = "runtime-global",
		default_value = "0,255,0",
		order = "h[color]",
	},
	]]
})

