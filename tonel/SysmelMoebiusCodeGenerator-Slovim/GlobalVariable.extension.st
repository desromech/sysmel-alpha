Extension { #name : #GlobalVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
GlobalVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createVariable: self class: objectModel globalVariableClass
]
