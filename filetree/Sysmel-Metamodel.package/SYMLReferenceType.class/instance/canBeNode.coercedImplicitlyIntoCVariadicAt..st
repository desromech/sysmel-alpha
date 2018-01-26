testing
canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition
	(super canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition) ifTrue: [ ^ true ].
	^ referenced canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition