Extension { #name : #Fraction }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Fraction >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createFractionInstance: self
]
