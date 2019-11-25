Extension { #name : #Symbol }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Symbol >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createSymbolObjectInstance: self
]
