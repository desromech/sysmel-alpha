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
Number >> u [
	^ self castTo: UInt32
]
