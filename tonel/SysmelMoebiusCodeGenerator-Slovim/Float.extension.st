Extension { #name : #Float }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Float >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createBoxedFloatInstance: self
]
