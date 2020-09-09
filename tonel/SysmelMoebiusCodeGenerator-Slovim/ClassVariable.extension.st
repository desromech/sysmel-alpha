Extension { #name : #ClassVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
ClassVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createVariable: self class: objectModel classVariableClass
]
