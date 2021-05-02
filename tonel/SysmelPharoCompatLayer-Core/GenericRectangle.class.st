Class {
	#name : #GenericRectangle,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'min',
		'max'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #constructing }
GenericRectangle class >> center: center extent: extent [
	^ self center: center halfExtent: extent / 2
]

{ #category : #constructing }
GenericRectangle class >> center: center halfExtent: halfExtent [
	^ self basicNew
		min: center - halfExtent;
		max: center + halfExtent;
		yourself
]

{ #category : #constructing }
GenericRectangle class >> empty [
	^ self basicNew
		min: self vector2Type infinityOrMaxValue;
		max: self vector2Type negativeInfinityOrMinValue;
		yourself
]

{ #category : #'instance creation' }
GenericRectangle class >> encompassing: listOfPoints [
	| result |
	result := self empty.
	listOfPoints do: [ :each | result insertPoint: each ].
	^ result
]

{ #category : #constructing }
GenericRectangle class >> extent: extent [
	^ self basicNew
		min: 0;
		max: extent;
		yourself
]

{ #category : #constructing }
GenericRectangle class >> fullSpace [
	^ self basicNew
		min: self vector2Type negativeInfinityOrMinValue;
		max: self vector2Type infinityOrMaxValue;
		yourself
]

{ #category : #constructing }
GenericRectangle class >> halfExtent: halfExtent [
	^ self basicNew
		min: halfExtent negated;
		max: halfExtent;
		yourself
]

{ #category : #testing }
GenericRectangle class >> isAbstract [
	^ self == GenericBox
]

{ #category : #serialization }
GenericRectangle class >> loadFromJson: jsonData [
	^ self min: (self vector2Type loadFromJson: (jsonData at: 'min'))
		max: (self vector2Type loadFromJson: (jsonData at: 'max'))
]

{ #category : #constructing }
GenericRectangle class >> min: min extent: extent [
	^ self basicNew
		min: min;
		max: min + extent;
		yourself
]

{ #category : #constructing }
GenericRectangle class >> min: min max: max [
	^ self basicNew
		min: min;
		max: max;
		yourself
]

{ #category : #constructing }
GenericRectangle class >> point: aPoint [
	^ self basicNew
		min: aPoint;
		max: aPoint;
		yourself
]

{ #category : #'as yet unclassified' }
GenericRectangle class >> typeOfGenericSlotNamed: slotName [
	slotName = #min ifTrue: [ ^ self vector2Type ].
	slotName = #max ifTrue: [ ^ self vector2Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #constructing }
GenericRectangle class >> unitRectangle [
	^ self min: -0.5 max: 0.5
]

{ #category : #comparing }
GenericRectangle >> = other [
	^ self class == other class and: [ min = other min and: [ max = other max ] ]
]

{ #category : #converting }
GenericRectangle >> asBox [
	^ self class boxType min: min asVector3 max: max asVector3
]

{ #category : #accessing }
GenericRectangle >> bottomLeft [
	^ min
]

{ #category : #accessing }
GenericRectangle >> bottomRight [
	^ self class vector2Type x: max x y: min y
]

{ #category : #accessing }
GenericRectangle >> center [
	^ min + ((max - min) / 2)
]

{ #category : #accessing }
GenericRectangle >> corners [
	^ {
		self bottomLeft .
		self bottomRight .
		self topRight .
		self topLeft .
	}
]

{ #category : #serialization }
GenericRectangle >> encodeForJSON [
	^ OrderedDictionary newFromPairs: {
		#min . min encodeForJSON.
		#max . max encodeForJSON.
	}
]

{ #category : #accessing }
GenericRectangle >> extent [
	^ max - min
]

{ #category : #accessing }
GenericRectangle >> halfExtent [
	^ (max - min) / 2
]

{ #category : #comparing }
GenericRectangle >> hash [
	^ min hash hashMultiply + max hash
]

{ #category : #accessing }
GenericRectangle >> height [
	^ max y - min y
]

{ #category : #initialization }
GenericRectangle >> initialize [
	min := self class vector2Type zeros.
	max := self class vector2Type zeros.
]

{ #category : #building }
GenericRectangle >> insertPoint: aPoint [
	min := min min: aPoint.
	max := max max: aPoint.
]

{ #category : #building }
GenericRectangle >> insertRectangle: aRectangle [
	min := min min: aRectangle min.
	max := max max: aRectangle max.
]

{ #category : #testing }
GenericRectangle >> isEmpty [
	^ min x > max x or: [ min y > max y ]
]

{ #category : #accessing }
GenericRectangle >> max [
	^ max
]

{ #category : #accessing }
GenericRectangle >> max: anObject [
	max := anObject implicitCastTo: self class vector2Type
]

{ #category : #accessing }
GenericRectangle >> min [
	^ min
]

{ #category : #accessing }
GenericRectangle >> min: anObject [
	min := anObject implicitCastTo: self class vector2Type
]

{ #category : #printing }
GenericRectangle >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name;
		nextPutAll: ' min: '; print: min;
		nextPutAll: ' max '; print: max;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GenericRectangle >> reversibleTransform3dToConvertToMe: sourceRectangle [
	| vector3Type |
	(self isEmpty or: [ sourceRectangle isEmpty ]) ifTrue: [ ^ self class reversibleAffineTransform3dType identity ].
	vector3Type := self class vector3Type.
	^ self class reversibleAffineTransform3dType identity
		translateBy: (vector3Type xy: sourceRectangle center negated z: 0);
		scaleBy: (vector3Type xy: self halfExtent / sourceRectangle halfExtent z: 1);
		translateBy: (vector3Type xy: self center z: 0);
		yourself.
]

{ #category : #'as yet unclassified' }
GenericRectangle >> reversibleTransformToConvertUnitRectangleToMe [
	^ self reversibleTransform3dToConvertToMe: self class unitRectangle
]

{ #category : #accessing }
GenericRectangle >> topLeft [
	^ self class vector2Type x: min x y: max y
]

{ #category : #accessing }
GenericRectangle >> topRight [
	^ max
]

{ #category : #transforming }
GenericRectangle >> translatedBy: translation [
	^ self class min: min + translation max: max + translation
]

{ #category : #accessing }
GenericRectangle >> width [
	^ max x - min x
]
