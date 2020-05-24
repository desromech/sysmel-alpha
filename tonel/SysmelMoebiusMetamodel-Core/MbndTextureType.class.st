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

{ #category : #initialization }
MbndTextureType >> addTextureIntrinsics [
	self class == MbndTextureType ifFalse: [ ^ self ].
	self isTraitType ifTrue: [ ^ self ].
	self
		addBuiltIn: #extent intrinsicNamed: 'texture.query.size' argumentTypes: #() returnType: self extentType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
		];
		addBuiltIn: #extentOfLod: intrinsicNamed: 'texture.query.lod.size' argumentTypes: { self compilationTarget int32Type } returnType: self extentType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
		];
		addBuiltIn: #lodCount intrinsicNamed: 'texture.query.lod.count' argumentTypes: #() returnType: self compilationTarget int32Type evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
		].
	
	sampled ifFalse: [ 
		
		self
			addBuiltIn: #loadAt: intrinsicNamed: 'texture.image.read' argumentTypes: {self imageCoordinateType}returnType: self compilationTarget voidType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #at:store: intrinsicNamed: 'texture.image.read' argumentTypes: {self imageCoordinateType . self texelType } returnType: self compilationTarget voidType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			]
	].
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

{ #category : #'as yet unclassified' }
MbndTextureType >> dimensionCount [
	dimensions = #cube ifTrue: [ ^ 3 ].
	^ dimensions
]

{ #category : #accessing }
MbndTextureType >> dimensions [
	^ dimensions
]

{ #category : #accessing }
MbndTextureType >> dimensions: anObject [
	dimensions := anObject
]

{ #category : #'as yet unclassified' }
MbndTextureType >> extentType [
	^ self compilationTarget int32Type primitiveVectorWithElements: self dimensionCount + layered asBit
]

{ #category : #'as yet unclassified' }
MbndTextureType >> imageCoordinateType [
	^ self compilationTarget int32Type primitiveVectorWithElements: self dimensionCount + layered asBit
]

{ #category : #initialization }
MbndTextureType >> initialize [
	super initialize.
	self
		addTextureIntrinsics
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
	^ self compilationTarget float32Type primitiveVectorWithElements: self dimensionCount + layered asBit
]

{ #category : #'as yet unclassified' }
MbndTextureType >> texelType [
	^ self compilationTarget float32Type primitiveVectorWithElements: 4
]
