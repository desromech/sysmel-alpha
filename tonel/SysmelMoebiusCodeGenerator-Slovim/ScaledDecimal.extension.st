Extension { #name : #ScaledDecimal }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
ScaledDecimal >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createScaledDecimalInstance: self
]
