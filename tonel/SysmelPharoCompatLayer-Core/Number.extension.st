Extension { #name : #Number }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> <=> other [
	^ (self - other) sign
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> f [
	^ self castTo: Float32
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> floatDivide: divisor [
	divisor = 0 ifTrue: [ 
		^ self = 0 ifTrue: [ Float nan ]
			ifFalse: [ self positive
					ifTrue: [ Float infinity ]
					ifFalse: [ Float negativeInfinity ]]
	].

	^ self asFloat / divisor asFloat
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> u [
	^ self castTo: UInt32
]
