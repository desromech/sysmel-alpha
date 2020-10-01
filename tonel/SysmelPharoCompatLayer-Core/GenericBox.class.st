Class {
	#name : #GenericBox,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'min',
		'max'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #constructing }
GenericBox class >> center: center extent: extent [
	^ self center: center halfExtent: extent / 2
]

{ #category : #constructing }
GenericBox class >> center: center halfExtent: halfExtent [
	^ self basicNew
		min: center - halfExtent;
		max: center + halfExtent;
		yourself
]

{ #category : #constructing }
GenericBox class >> empty [
	^ self basicNew
		min: self vector3Type infinityOrMaxValue;
		max: self vector3Type negativeInfinityOrMinValue;
		yourself
]

{ #category : #constructing }
GenericBox class >> extent: extent [
	^ self basicNew
		min: 0;
		max: extent;
		yourself
]

{ #category : #constructing }
GenericBox class >> fullSpace [
	^ self basicNew
		min: self vector3Type negativeInfinityOrMinValue;
		max: self vector3Type infinityOrMaxValue;
		yourself
]

{ #category : #testing }
GenericBox class >> isAbstract [
	^ self == GenericBox
]

{ #category : #constructing }
GenericBox class >> min: min extent: extent [
	^ self basicNew
		min: min;
		max: min + extent;
		yourself
]

{ #category : #constructing }
GenericBox class >> min: min max: max [
	^ self basicNew
		min: min;
		max: max;
		yourself
]

{ #category : #constructing }
GenericBox class >> point: aPoint [
	^ self basicNew
		min: aPoint;
		max: aPoint;
		yourself
]

{ #category : #constructing }
GenericBox class >> unitBox [
	^ self min: 0.5 max: 0.5
]

{ #category : #converting }
GenericBox >> asBoxF32 [
	^ BoxF32 basicNew
		min: (min castTo: Float32x2);
		max: (max castTo: Float32x2);
		yourself
]

{ #category : #converting }
GenericBox >> asBoxF64 [
	^ BoxF64 basicNew
		min: (min castTo: Float64x2);
		max: (max castTo: Float64x2);
		yourself
]

{ #category : #converting }
GenericBox >> asBoxI32 [
	^ BoxI32 basicNew
		min: (min castTo: Int32x2);
		max: (max castTo: Int32x2);
		yourself
]

{ #category : #accessing }
GenericBox >> center [
	^ min + ((max - min) / 2)
]

{ #category : #accessing }
GenericBox >> corners [
	^ { 
		self nearBottomLeft.
		self nearBottomRight.
		self nearTopLeft.
		self nearTopRight.

		self farBottomLeft.
		self farBottomRight.
		self farTopLeft.
		self farTopRight
	}
]

{ #category : #accessing }
GenericBox >> depth [
	^ max z - min z
]

{ #category : #serialization }
GenericBox >> encodeForJSON [
	^ OrderedDictionary newFromPairs: {
		#min . min encodeForJSON.
		#max . max encodeForJSON.
	}
]

{ #category : #accessing }
GenericBox >> extent [
	^ max - min
]

{ #category : #accessing }
GenericBox >> farBottomLeft [
	^ self class vector3Type x: min x y: min y z: max z
]

{ #category : #accessing }
GenericBox >> farBottomRight [
	^ self class vector3Type x: max x y:min y z: max z
]

{ #category : #accessing }
GenericBox >> farTopLeft [
	^ self class vector3Type x: min x y: max y z: max z
]

{ #category : #accessing }
GenericBox >> farTopRight [
	^ max
]

{ #category : #accessing }
GenericBox >> halfExtent [
	^ (max - min) / 2
]

{ #category : #testing }
GenericBox >> hasIntersectionWithBox: other [
	^ (self isBoxOutside: other) not
]

{ #category : #accessing }
GenericBox >> height [
	^ max y - min y
]

{ #category : #testing }
GenericBox >> includesBox: other [
	^ min x <= other min x and: [other max x <= max x and: [
		min y <= other min y and: [other max y <= max y and: [
		min z <= other min z and: [other max z <= max z ]]]]]
]

{ #category : #testing }
GenericBox >> includesBoxExclusively: other [
	^ min x <= other min x and: [other max x < max x and: [
		min y <= other min y and: [other max y < max y and: [
		min z <= other min z and: [other max z < max z ]]]]]
]

{ #category : #testing }
GenericBox >> includesPoint: point [
	^ min x <= point x and: [point x <= max x and: [
		min y <= point y and: [point y <= max y and: [
		min z <= point z and: [point z <= max z ]]]]]
]

{ #category : #testing }
GenericBox >> includesPointExclusively: point [
	^ min x <= point x and: [point x < max x and: [
		min y <= point y and: [point y < max y and: [
		min z <= point z and: [point z < max z ]]]]]
]

{ #category : #initialization }
GenericBox >> initialize [
	min := self class vector3Type zeros.
	max := self class vector3Type zeros.
]

{ #category : #intersection }
GenericBox >> intersectionWith: other [
	^ self class basicNew
		min: (min max: other min);
		max: (max min: other min);
		yourself
]

{ #category : #testing }
GenericBox >> isBoxOutside: other [
	^ other max x < min x or: [ max x < other min x or: [
	  other max y < min y or: [ max y < other min y or: [
	  other max z < min z or: [ max z < other min z ]]]]]
]

{ #category : #testing }
GenericBox >> isEmpty [
	^ min x > max x or: [ min y > max y or: [min z > max z]]
]

{ #category : #accessing }
GenericBox >> max [
	^ max
]

{ #category : #accessing }
GenericBox >> max: anObject [
	max := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericBox >> min [
	^ min
]

{ #category : #accessing }
GenericBox >> min: anObject [
	min := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericBox >> nearBottomLeft [
	^ min
]

{ #category : #accessing }
GenericBox >> nearBottomRight [
	^ self class vector3Type x: max x y: min y z: min z
]

{ #category : #accessing }
GenericBox >> nearTopLeft [
	^ self class vector3Type x: min x y: max y z: min z
]

{ #category : #accessing }
GenericBox >> nearTopRight [
	^ self class vector3Type x: max x y: max y z: min z
]

{ #category : #accessing }
GenericBox >> negativeVertex: direction [
	| vertex |
	vertex := max copy.
	direction x >= 0.0 ifTrue: [ vertex x: min x ].
	direction y >= 0.0 ifTrue: [ vertex x: min y ].
	direction z >= 0.0 ifTrue: [ vertex x: min z ].
	^ vertex
]

{ #category : #accessing }
GenericBox >> positiveVertex: direction [
	| vertex |
	vertex := min copy.
	direction x >= 0.0 ifTrue: [ vertex x: max x ].
	direction y >= 0.0 ifTrue: [ vertex x: max y ].
	direction z >= 0.0 ifTrue: [ vertex x: max z ].
	^ vertex
]

{ #category : #printing }
GenericBox >> printOn: aStream [
	self isEmpty ifTrue: [ 
		^ aStream nextPutAll: self class name; nextPutAll: ' empty'
	].

	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll:  ' min: '; print: min;
		nextPutAll:  ' max: '; print: max;
		nextPut: $)
]

{ #category : #accessing }
GenericBox >> support: direction [
	^ self positiveVertex: direction
]

{ #category : #transforming }
GenericBox >> translatedBy: translation [
	^ self class min: min + translation max: max + translation
]

{ #category : #'as yet unclassified' }
GenericBox >> unionWith: other [
	^ other class isPrimitiveVectorType ifTrue: [
		self unionWithPoint: other
	] ifFalse: [ 
		self unionWithBox: other
	]
]

{ #category : #'as yet unclassified' }
GenericBox >> unionWithBox: other [
	^ self class basicNew
		min: (min min: other min);
		max: (max max: other max);
		yourself
]

{ #category : #'as yet unclassified' }
GenericBox >> unionWithPoint: point [
	^ self class basicNew
		min: (min min: point);
		max: (max max: point);
		yourself
]

{ #category : #accessing }
GenericBox >> width [
	^ max x - min x
]
