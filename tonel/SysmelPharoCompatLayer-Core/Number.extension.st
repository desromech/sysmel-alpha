Extension { #name : #Number }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> <=> other [
	^ (self - other) sign
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> asFloatFromNormalizedSByte [
	^ self asFloat / 16r7F min: 1.0 max: -1.0
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> asFloatFromNormalizedSShort [
	^ self asFloat / 16r7FFF.0 min: 1.0 max: -1.0
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> asFloatFromNormalizedUByte [
	^ self asFloat / 255.0
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Number >> asFloatFromNormalizedUShort [
	^ self asFloat / 65535.0
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
