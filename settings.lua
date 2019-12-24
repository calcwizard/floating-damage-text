
data:extend({ 	

	-- startup
	{
		type = "int-setting",
		name = "floating-damage-lifetime",
		setting_type = "startup",
		default_value = 30,
		minimum_value = 1,
		order = "da-[life]"
	},
	{
		type = "double-setting",
		name = "floating-damage-velocity",
		setting_type = "startup",
		default_value = 0.5,
		order = "da-[velocity]"
	},




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
	{
		type = "string-setting",
		name = "floating-healing-string-format",
		setting_type = "runtime-global",
		default_value = "%s",
		allow_blank = true,
		order = "ha-[format]",
	},
	{
		type = "string-setting",
		name = "floating-healing-color",
		setting_type = "runtime-global",
		default_value = "0,255,0",
		order = "hb-[color]",
	},
	{
		type = "int-setting",
		name = "floating-healing-interval",
		setting_type = "runtime-global",
		default_value = 60,
		minimum_value = 1,
		order = "hc-[interval]",		
	},
})

