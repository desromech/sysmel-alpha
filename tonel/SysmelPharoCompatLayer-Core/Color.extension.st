Extension { #name : #Color }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat32x4 [
	^ Float32x4 x: self red y: self green z: self blue w: self alpha
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Color >> asFloat64x4 [
	^ Float64x4 x: self red y: self green z: self blue w: self alpha
]
