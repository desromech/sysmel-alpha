Extension { #name : #Integer }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Integer >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createLargeIntegerInstance: self
]
