Extension { #name : #Color }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat32x3 [
	^ Float32x4 x: self red decodeSRGBComponent y: self green decodeSRGBComponent z: self blue decodeSRGBComponent
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat32x4 [
	^ Float32x4 x: self red decodeSRGBComponent y: self green decodeSRGBComponent z: self blue decodeSRGBComponent w: self alpha
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat64x3 [
	^ Float64x4 x: self red decodeSRGBComponent y: self green decodeSRGBComponent z: self blue decodeSRGBComponent
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat64x4 [
	^ Float64x4 x: self red decodeSRGBComponent y: self green decodeSRGBComponent z: self blue decodeSRGBComponent w: self alpha
]
