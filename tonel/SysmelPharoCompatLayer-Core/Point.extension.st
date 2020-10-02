Extension { #name : #Point }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Point >> asFloat32x2 [
	^ Float32x2 x: x y: y
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Point >> asFloat64x2 [
	^ Float64x2 x: x y: y
]
