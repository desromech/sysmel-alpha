Class {
	#name : #SysmelPrimitiveVectorType,
	#superclass : #SysmelPrimitiveType,
	#classInstVars : [
		'vector2Type',
		'vector3Type',
		'vector4Type'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVectorType class >> elementType [
	^ self subclassResponsibility
]

{ #category : #accessing }
SysmelPrimitiveVectorType class >> elements [
	^ self subclassResponsibility
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> infinity [
	^ self withAll: self elementType infinity
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> infinityOrMaxValue [
	^ self withAll: self elementType infinityOrMaxValue
]

{ #category : #sizes }
SysmelPrimitiveVectorType class >> instanceSize [
	^ self elementType instanceSize * self elements
]

{ #category : #testing }
SysmelPrimitiveVectorType class >> isAbstract [
	^ self == SysmelPrimitiveVectorType
]

{ #category : #testing }
SysmelPrimitiveVectorType class >> isPrimitiveVectorType [
	^ true
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> maxValue [
	^ self withAll: self elementType maxValue
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> minValue [
	^ self withAll: self elementType minValue
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> negativeInfinity [
	^ self withAll: self elementType negativeInfinity
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> negativeInfinityOrMinValue [
	^ self withAll: self elementType negativeInfinityOrMinValue
]

{ #category : #'instance creation' }
SysmelPrimitiveVectorType class >> new [
	^ self zeros
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> ones [
	^ self withAll: self elementType ones
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVectorType class >> validateExplicitCastOfValue: aValue [
	aValue class == self ifTrue: [ ^ aValue ].
	
	aValue class isPrimitiveVectorType ifTrue: [
		aValue class elements = self elements ifFalse: [
			self error: 'Cannot cast vectors with mismatching number of elements.'
		].
	
		^ aValue collect: [ :each | each castTo: self elementType ] as: self
	].

	^ super validateExplicitCastOfValue: aValue
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveVectorType class >> validateImplicitCastOfValue: aValue [
	aValue isNumber ifTrue: [
		| castedNumber |
		castedNumber := aValue implicitCastTo: self elementType.
		^ self withAll: castedNumber
	].

	^ super validateImplicitCastOfValue: aValue
]

{ #category : #accessing }
SysmelPrimitiveVectorType class >> vector2Type [
	^ vector2Type ifNil: [vector2Type := self scalarType primitiveVectorWithElements: 2]
]

{ #category : #accessing }
SysmelPrimitiveVectorType class >> vector3Type [
	^ vector3Type ifNil: [vector3Type := self scalarType primitiveVectorWithElements: 3]
]

{ #category : #accessing }
SysmelPrimitiveVectorType class >> vector4Type [
	^ vector4Type ifNil: [vector4Type := self scalarType primitiveVectorWithElements: 4]
]

{ #category : #'instance creation' }
SysmelPrimitiveVectorType class >> withAll: element [
	self subclassResponsibility
]

{ #category : #constants }
SysmelPrimitiveVectorType class >> zeros [
	^ self withAll: self elementType zero
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> * other [
	other isPrimitiveMatrix ifTrue: [ ^ other preMultiplyVector: self ].
	^ self with: other collect: [ :a :b | a * b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> + other [
	^ self with: other collect: [ :a :b | a + b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> - other [
	^ self with: other collect: [ :a :b | a - b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> / other [
	^ self class elementType isPrimitiveFloatType ifTrue: [ 
		self with: other collect: [ :a :b |
			a floatDivide: b
		]
	] ifFalse: [ 
		self with: other collect: [ :a :b |
			a // b
		]
	]

]

{ #category : #comparing }
SysmelPrimitiveVectorType >> < other [
	^ (self <=> other) < 0
]

{ #category : #comparing }
SysmelPrimitiveVectorType >> <= other [
	^ (self <=> other) <= 0
]

{ #category : #comparing }
SysmelPrimitiveVectorType >> <=> other [
	self subclassResponsibility
]

{ #category : #comparing }
SysmelPrimitiveVectorType >> > other [
	^ (self <=> other) > 0
]

{ #category : #comparing }
SysmelPrimitiveVectorType >> >= other [
	^ (self <=> other) >= 0
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> abs [
	^ self collect: [ :each | each abs ]
]

{ #category : #converting }
SysmelPrimitiveVectorType >> adaptToNumber: rcvr andSend: selector [
	^ (rcvr implicitCastTo: self class) perform: selector with: self
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> ceiling [
	^ self collect: [ :each | each ceiling ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> collect: aBlock [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> collect: aBlock as: resultType [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> dot: other [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> floor [
	^ self collect: [ :each | each floor ]
]

{ #category : #testing }
SysmelPrimitiveVectorType >> isOnes [
	^ self = 1
]

{ #category : #testing }
SysmelPrimitiveVectorType >> isPrimitiveVector [
	^ true
]

{ #category : #testing }
SysmelPrimitiveVectorType >> isZero [
	^ false
]

{ #category : #testing }
SysmelPrimitiveVectorType >> isZeros [
	^ self = 0
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> length [
	^ (self dot: self) sqrt
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> length2 [
	^ self dot: self
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> max: other [
	^ self with: other collect: [ :a :b | a max: b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> min: other [
	^ self with: other collect: [ :a :b | a min: b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> negated [
	^ self collect: [ :each | each negated ]
]

{ #category : #accessing }
SysmelPrimitiveVectorType >> normalized [
	| l |
	l := self length.
	(l closeTo: 0) ifTrue: [ ^ self class zeros ].
	^ self collect: [ :each | each / l ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> sqrt [
	^ self collect: [ :each | each sqrt ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> with: other collect: aBlock [
	self subclassResponsibility
]
