Extension { #name : #ByteArray }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
ByteArray >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createObjectBytes: self class: objectModel byteArrayClass
]
