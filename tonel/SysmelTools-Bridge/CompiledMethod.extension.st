Extension { #name : #CompiledMethod }

{ #category : #'*SysmelTools-Bridge' }
CompiledMethod >> encodeForSysmelBridge [
	| bytecodes destIndex |
	bytecodes := ByteArray new: self endPC - self initialPC + 1.
	destIndex := 1.
	self initialPC to: self endPC do: [ :i | 
		bytecodes at: destIndex put: (self at: i).
		destIndex := destIndex + 1
	].

	^ Dictionary newFromPairs: {
		#type . #CompiledMethod .
		#literals . self literals collect: [ :each | each encodeForSysmelBridge ].
		#bytecodes . bytecodes.
		#numArgs . self numArgs.
		#numTemps . self numTemps.
	}
]
