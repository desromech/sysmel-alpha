Extension { #name : #Array }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Array >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createArray: self class: objectModel arrayClass
]
