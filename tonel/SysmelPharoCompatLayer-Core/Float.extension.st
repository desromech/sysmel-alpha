Extension { #name : #Float }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> asNormalizedSByte [
	^ (self * 16r7F) asInteger bitAnd: 16rFF
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> asNormalizedShort [
	^ (self * 16r7FFF) asInteger bitAnd: 16rFFFF
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> asNormalizedUByte [
	^ (self * 16rFF) asInteger min: 16rFF max: 0
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> asNormalizedUShort [
	^ (self * 16rFFFF) asInteger min: 16rFFFF max: 0
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> decodeSRGBComponent [
	"
	From: https://en.wikipedia.org/wiki/SRGB
	"
	| a |
	a := 0.055.
	^ self <= 0.04045 ifTrue: [ self / 12.92 ] ifFalse: [ ((self + a) / (1.0 + a)) raisedTo: 2.4 ]
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Float >> encodeSRGBComponent [
	"
	From: https://en.wikipedia.org/wiki/SRGB
	"
	| a |
	a := 0.055.
	^ self <= 0.0031308 ifTrue: [ self * 12.92 ] ifFalse: [ ((1.0 + a) * (self raisedTo: 1.0 / 2.4)) - a ]
]
