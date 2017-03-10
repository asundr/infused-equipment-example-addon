# infused-equipment-example-addon
Author: Arun Sundaram

Plugin Page:	http://www.nexusmods.com/skyrimspecialedition/mods/8705

Infused Equipment is a plugin for The Elder Scrolls V: Skyrim that makes use of its own scripting language
[Papyrus](http://www.creationkit.com/index.php?title=Category:Papyrus). The scripts contained here are for an example
plugin that can be found in the miscellaneous downloads of the [Plugin Page](http://www.nexusmods.com/skyrimspecialedition/mods/8705).

Infused Equipment serves as a framework for other authors to add their own abilities seamlessly such as with 
these scripts. [See here for the original scripts.] (https://github.com/asundr/infused-equipment)

- **RegisterPlugin**: Notifies the main plugin that a 3rd party plugin is being installed then installs the
		contents of this plugin.

- **FireTrail**: An example ability that shows how to make use of the inherited functionality from AbilityBase
		and expand upon it to add unique behavior

- **TestRechargeSource**: An example recharge source to show how use custom recharge sources with abilities.
		For a detailed example of a functional RechargeSource see DistanceTravelled or MagickaSiphon from the
		main plugin.