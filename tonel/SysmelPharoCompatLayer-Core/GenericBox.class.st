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

{ #category : #accessing }
GenericBox >> center [
	^ min + ((max - min) / 2)
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
GenericBox >> height [
	^ max y - min y
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

{ #category : #transforming }
GenericBox >> translatedBy: translation [
	^ self class min: min + translation max: max + translation
]

{ #category : #accessing }
GenericBox >> width [
	^ max x - min x
]
