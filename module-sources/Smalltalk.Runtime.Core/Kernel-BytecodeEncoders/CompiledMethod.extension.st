Extension { #name : #CompiledMethod }

{ #category : #'*opalcompiler-core' }
CompiledMethod class >> headerFlagForEncoder: anEncoderClass [
	anEncoderClass == EncoderForV3PlusClosures ifTrue: [ ^ 0 ].
	anEncoderClass == EncoderForSistaV1 ifTrue: [ ^ SmallInteger minVal ].

	self error: 'The encoder is not one of the two installed bytecode sets'.
	^ 0
]
