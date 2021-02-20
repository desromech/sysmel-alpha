Extension { #name : #MbndPrimitiveType }

{ #category : #'*SysmelPharoCompatLayer-Core' }
MbndPrimitiveType >> asPharoCompatLayerType [
	^ self class environment at: name
]
