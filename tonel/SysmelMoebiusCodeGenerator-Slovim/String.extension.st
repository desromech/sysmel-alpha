Extension { #name : #String }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
String >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createObjectBytes: self asUTF8Bytes class: objectModel stringClass
]
