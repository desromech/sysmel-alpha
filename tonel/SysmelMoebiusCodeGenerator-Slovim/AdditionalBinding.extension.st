Extension { #name : #AdditionalBinding }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
AdditionalBinding >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createVariable: self class: objectModel additionalBindingClass
]
