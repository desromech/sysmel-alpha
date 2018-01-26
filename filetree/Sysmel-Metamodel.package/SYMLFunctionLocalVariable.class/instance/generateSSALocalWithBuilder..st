code generation
generateSSALocalWithBuilder: builder
	self assert: ssaValue isNil.
	ssaValue := builder allocaBuilder alloca: valueType ssaType name: (name ifNil: [ builder function generateSymbol])