Class {
	#name : #MbndTextureType,
	#superclass : #MbndOpaqueHandleType,
	#instVars : [
		'sampled',
		'dimensions',
		'layered',
		'depth',
		'multisampling'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTextureType class >> typeName [
	^ #GpuTextureType
]

{ #category : #visiting }
MbndTextureType >> accept: visitor [
	^ visitor visitTextureType: self
]

{ #category : #accessing }
MbndTextureType >> depth [
	^ depth
]

{ #category : #accessing }
MbndTextureType >> depth: anObject [
	depth := anObject
]

{ #category : #'as yet unclassified' }
MbndTextureType >> derivativeType [
	^ self compilationTarget float32Type primitiveVectorWithElements: dimensions
]

{ #category : #accessing }
MbndTextureType >> dimensions [
	^ dimensions
]

{ #category : #accessing }
MbndTextureType >> dimensions: anObject [
	dimensions := anObject
]

{ #category : #'testing methods' }
MbndTextureType >> isTextureType [
	^ true
]

{ #category : #accessing }
MbndTextureType >> layered [
	^ layered
]

{ #category : #accessing }
MbndTextureType >> layered: anObject [
	layered := anObject
]

{ #category : #accessing }
MbndTextureType >> multisampling [
	^ multisampling
]

{ #category : #accessing }
MbndTextureType >> multisampling: anObject [
	multisampling := anObject
]

{ #category : #accessing }
MbndTextureType >> sampled [
	^ sampled
]

{ #category : #accessing }
MbndTextureType >> sampled: anObject [
	sampled := anObject
]

{ #category : #'as yet unclassified' }
MbndTextureType >> samplingCoordinateType [
	^ self compilationTarget float32Type primitiveVectorWithElements: dimensions + layered asBit
]
