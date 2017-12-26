converting
buildAPSG: builder
	^ (builder literal: (self evaluateInEnvironment: builder environment))
		position: self