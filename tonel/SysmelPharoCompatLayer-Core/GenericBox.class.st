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

{ #category : #'instance creation' }
GenericBox class >> encompassing: listOfPoints [
	| result |
	result := self empty.
	listOfPoints do: [ :each | result insertPoint: each ].
	^ result
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

{ #category : #constructing }
GenericBox class >> halfExtent: halfExtent [
	^ self basicNew
		min: halfExtent negated;
		max: halfExtent;
		yourself
]

{ #category : #testing }
GenericBox class >> isAbstract [
	^ self == GenericBox
]

{ #category : #serialization }
GenericBox class >> loadFromJson: jsonData [
	^ self min: (self vector3Type loadFromJson: (jsonData at: 'min'))
		max: (self vector3Type loadFromJson: (jsonData at: 'max'))
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

{ #category : #'as yet unclassified' }
GenericBox class >> typeOfGenericSlotNamed: slotName [
	slotName = #min ifTrue: [ ^ self vector3Type ].
	slotName = #max ifTrue: [ ^ self vector3Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #constructing }
GenericBox class >> unitBox [
	^ self min: -0.5 max: 0.5
]

{ #category : #comparing }
GenericBox >> = other [
	^ self class == other class and: [ min = other min and: [ max = other max ] ]
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

{ #category : #'as yet unclassified' }
GenericBox >> asFrustum [
	^ self class frustumType basicNew
		makeOrthoLeft: min x right: max x
		bottom: min y top: max y
		near: max z negated far: min z negated;
		yourself.
]

{ #category : #converting }
GenericBox >> asRectangleXY [
	^ self class rectangleType min: min xy max: max xy
]

{ #category : #accessing }
GenericBox >> bottomPoint [
	^ (self leftBottomPoint + self rightBottomPoint) / 2
]

{ #category : #accessing }
GenericBox >> center [
	^ min + ((max - min) / 2)
]

{ #category : #'as yet unclassified' }
GenericBox >> computeNormalForPoint: point [
	^ (self computePenetrationNormalAndDistanceForPoint: point) first
]

{ #category : #'as yet unclassified' }
GenericBox >> computePenetrationNormalAndDistanceForPoint: point [
	| delta deltaAbsolute normal penetrationDistance |
	delta := point - self center.
	deltaAbsolute := delta abs / self halfExtent.
	normal := deltaAbsolute x >= deltaAbsolute y ifTrue: [
			deltaAbsolute x >= deltaAbsolute z ifTrue: [
				self class vector3Type x: delta x sign
			] ifFalse: [ 
				self class vector3Type z: delta z sign
			]
		] ifFalse: [
			deltaAbsolute y >= deltaAbsolute z ifTrue: [
				self class vector3Type y: delta y sign
			] ifFalse: [
				self class vector3Type z: delta z sign
			].
		].
	penetrationDistance := (delta - (self halfExtent*normal) dot: normal) abs.
	^ {normal . penetrationDistance}
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
GenericBox >> cornersDo: aBlock [
	aBlock value: self nearBottomLeft.
	aBlock value: self nearBottomRight.
	aBlock value: self nearTopLeft.
	aBlock value: self nearTopRight.

	aBlock value: self farBottomLeft.
	aBlock value: self farBottomRight.
	aBlock value: self farTopLeft.
	aBlock value: self farTopRight.

	^ nil.

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
GenericBox >> farBottomPoint [
	^ (self farBottomLeft + self farBottomRight) / 2
]

{ #category : #accessing }
GenericBox >> farBottomRight [
	^ self class vector3Type x: max x y:min y z: max z
]

{ #category : #accessing }
GenericBox >> farLeftPoint [
	^ (self farBottomLeft + self farTopLeft) / 2
]

{ #category : #accessing }
GenericBox >> farPoint [
	^ (self farLeftPoint + self farRightPoint) / 2
]

{ #category : #accessing }
GenericBox >> farRightPoint [
	^ (self farBottomRight + self farTopRight) / 2
]

{ #category : #accessing }
GenericBox >> farTopLeft [
	^ self class vector3Type x: min x y: max y z: max z
]

{ #category : #accessing }
GenericBox >> farTopPoint [
	^ (self farTopLeft + self farTopRight) / 2
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

{ #category : #'as yet unclassified' }
GenericBox >> hasIntersectionWithRay: ray [
	^ (self intersectionWithRay: ray) isNotNil.
]

{ #category : #comparing }
GenericBox >> hash [
	^ min hash hashMultiply + max hash
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

{ #category : #building }
GenericBox >> insertBox: aBox [
	min := min min: aBox min.
	max := max max: aBox max.
]

{ #category : #building }
GenericBox >> insertPoint: aPoint [
	min := min min: aPoint.
	max := max max: aPoint.
]

{ #category : #intersection }
GenericBox >> intersectionWith: other [
	^ self class basicNew
		min: (min max: other min);
		max: (max min: other max);
		yourself
]

{ #category : #'as yet unclassified' }
GenericBox >> intersectionWithRay: ray [
	"Slab testing algorithm from: A Ray-Box Intersection Algorithm andEfficient Dynamic Voxel Rendering. By Majercik et al"
	| t0 t1 tmin tmax maxTMin minTMax hasIntersection |
	t0 := (min - ray origin)*ray inverseDirection.
	t1 := (max - ray origin)*ray inverseDirection.
	tmin := t0 min: t1.
	tmax := t0 max: t1.
	maxTMin := ((tmin x max: tmin y) max: tmin z) max: ray tmin.
	minTMax := ((tmax x min: tmax y) min: tmax z) min: ray tmax.

	hasIntersection := maxTMin <= minTMax.
 	hasIntersection ifFalse: [ ^ nil ].

	^ maxTMin min: minTMax
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
GenericBox >> leftBottomPoint [
	^ (self nearBottomLeft + self farBottomLeft) / 2
]

{ #category : #accessing }
GenericBox >> leftPoint [
	^ (self leftBottomPoint + self leftTopPoint) / 2
]

{ #category : #accessing }
GenericBox >> leftTopPoint [
	^ (self nearTopLeft + self farTopLeft) / 2
]

{ #category : #accessing }
GenericBox >> manipulationPoints [
	^ { 
		self nearBottomLeft .
		self nearBottomRight .
		self nearTopLeft .	
		self nearTopRight .

		self farBottomLeft .
		self farBottomRight .
		self farTopLeft .
		self farTopRight .

		self nearLeftPoint .
		self nearRightPoint .
		self nearTopPoint .
		self nearBottomPoint .

		self farLeftPoint .
		self farRightPoint .
		self farTopPoint .
		self farBottomPoint .

		self leftBottomPoint .
		self rightBottomPoint .
		self leftTopPoint .
		self rightTopPoint .

		self leftPoint .
		self rightPoint .
		self bottomPoint .
		self topPoint .
		self nearPoint .
		self farPoint .
	}
]

{ #category : #'as yet unclassified' }
GenericBox >> mappingToNDCCoordinates [
	^ self mappingToNDCCoordinatesInvertedY: false
]

{ #category : #'as yet unclassified' }
GenericBox >> mappingToNDCCoordinatesInvertedY: invertedY [
	^ self class matrix4x4Type orthoLeft: min x right: max x
            	bottom: min y top: max y
            	near: max z negated far: min z negated invertedY: invertedY.
]

{ #category : #'as yet unclassified' }
GenericBox >> mappingToNDCCoordinatesReverseDepth [
	^ self mappingToNDCCoordinatesReverseDepthWithInvertedY: false
]

{ #category : #'as yet unclassified' }
GenericBox >> mappingToNDCCoordinatesReverseDepthWithInvertedY: invertedY [
	^ self class matrix4x4Type reverseDepthOrthoLeft: min x right: max x
		bottom: min y top: max y
		near: max z negated far: min z negated
		invertedY: invertedY
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
GenericBox >> nearBottomPoint [
	^ (self nearBottomLeft + self nearBottomRight) / 2
]

{ #category : #accessing }
GenericBox >> nearBottomRight [
	^ self class vector3Type x: max x y: min y z: min z
]

{ #category : #accessing }
GenericBox >> nearLeftPoint [
	^ (self nearBottomLeft + self nearTopLeft) / 2
]

{ #category : #accessing }
GenericBox >> nearPoint [
	^ (self nearLeftPoint + self nearRightPoint) / 2
]

{ #category : #accessing }
GenericBox >> nearRightPoint [
	^ (self nearBottomRight + self nearTopRight) / 2
]

{ #category : #accessing }
GenericBox >> nearTopLeft [
	^ self class vector3Type x: min x y: max y z: min z
]

{ #category : #accessing }
GenericBox >> nearTopPoint [
	^ (self nearTopLeft + self nearTopRight) / 2
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
	direction y >= 0.0 ifTrue: [ vertex y: min y ].
	direction z >= 0.0 ifTrue: [ vertex z: min z ].
	^ vertex
]

{ #category : #'as yet unclassified' }
GenericBox >> octants [
	| center vector3Type |
	center := self center.
	vector3Type := self class vector3Type.
	^ {
		"Bottom quadrant"

		"Left near"
		self class min: (vector3Type x: min x y: min y z: min z) max: (vector3Type x: center x y: center y z: center z).
		"Right near"
		self class min: (vector3Type x: center x y: min y z: min z) max: (vector3Type x: max x y: center y z: center z).
		"Left far"
		self class min: (vector3Type x: min x y: min y z: center z) max: (vector3Type x: center x y: center y z: max z).
		"Right far"
		self class min: (vector3Type x: center x y: min y z: center z) max: (vector3Type x: max x y: center y z: max z).

		"Top quadrant"
		"Left near"
		self class min: (vector3Type x: min x y: center y z: min z) max: (vector3Type x: center x y: max y z: center z).
		"Right near"
		self class min: (vector3Type x: center x y: center y z: min z) max: (vector3Type x: max x y: max y z: center z).
		"Left far"
		self class min: (vector3Type x: min x y: center y z: center z) max: (vector3Type x: center x y: max y z: max z).
		"Right far"
		self class min: (vector3Type x: center x y: center y z: center z) max: (vector3Type x: max x y: max y z: max z).
	}
]

{ #category : #accessing }
GenericBox >> positiveVertex: direction [
	| vertex |
	vertex := min copy.
	direction x >= 0.0 ifTrue: [ vertex x: max x ].
	direction y >= 0.0 ifTrue: [ vertex y: max y ].
	direction z >= 0.0 ifTrue: [ vertex z: max z ].
	^ vertex
]

{ #category : #printing }
GenericBox >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll: ' min: '; print: min;
		nextPutAll: ' max '; print: max;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GenericBox >> quadrants [
	| center vector3Type |
	center := self center.
	vector3Type := self class vector3Type.
	^ {
		"Left near"
		self class min: (vector3Type x: min x y: min y z: min z) max: (vector3Type x: center x y: max y z: center z).
		"Right near"
		self class min: (vector3Type x: center x y: min y z: min z) max: (vector3Type x: max x y: max y z: center z).
		"Left far"
		self class min: (vector3Type x: min x y: min y z: center z) max: (vector3Type x: center x y: max y z: max z).
		"Right far"
		self class min: (vector3Type x: center x y: min y z: center z) max: (vector3Type x: max x y: max y z: max z).
	}
]

{ #category : #'as yet unclassified' }
GenericBox >> reversibleTransformToConvertToMe: sourceBox [
	(self isEmpty or: [ sourceBox isEmpty ]) ifTrue: [ ^ self class reversibleAffineTransform3dType identity ].
	^ self class reversibleAffineTransform3dType identity
		translateBy: sourceBox center negated;
		scaleBy: self halfExtent / sourceBox halfExtent;
		translateBy: self center;
		yourself.
]

{ #category : #'as yet unclassified' }
GenericBox >> reversibleTransformToConvertUnitBoxToMe [
	^ self reversibleTransformToConvertToMe: self class unitBox
]

{ #category : #accessing }
GenericBox >> rightBottomPoint [
	^ (self nearBottomRight + self farBottomRight) / 2
]

{ #category : #accessing }
GenericBox >> rightPoint [
	^ (self rightBottomPoint + self rightTopPoint) / 2
]

{ #category : #accessing }
GenericBox >> rightTopPoint [
	^ (self nearTopRight + self farTopRight) / 2
]

{ #category : #accessing }
GenericBox >> support: direction [
	^ self positiveVertex: direction
]

{ #category : #accessing }
GenericBox >> topPoint [
	^ (self leftTopPoint + self rightTopPoint) / 2
]

{ #category : #transforming }
GenericBox >> transformedWith: transform [
	| result |
	result := self class empty.
	self cornersDo: [ :each |
		result insertPoint: (transform transformPosition: each)
	].
	^ result
]

{ #category : #transforming }
GenericBox >> translatedBy: translation [
	^ self class min: min + translation max: max + translation
]

{ #category : #building }
GenericBox >> unionWith: other [
	^ other class isPrimitiveVectorType ifTrue: [
		self unionWithPoint: other
	] ifFalse: [ 
		self unionWithBox: other
	]
]

{ #category : #building }
GenericBox >> unionWithBox: other [
	^ self class basicNew
		min: (min min: other min);
		max: (max max: other max);
		yourself
]

{ #category : #building }
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

{ #category : #'as yet unclassified' }
GenericBox >> withExpandedHalfExtent: extension [
	^ self class center: self center halfExtent: self halfExtent + extension
]
