accessing
tryToStyle: token into: commands
	[
		self style: token into: commands
	] on: Error do: [ :err | ]