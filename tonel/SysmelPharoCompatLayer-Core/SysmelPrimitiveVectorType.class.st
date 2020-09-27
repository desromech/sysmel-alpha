Class {
	#name : #SysmelPrimitiveVectorType,
	#superclass : #SysmelPrimitiveType,
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

{ #category : #constants }
SysmelPrimitiveVectorType class >> ones [
	^ self withAll: self elementType ones
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
	^ self with: other collect: [ :a :b | a / b ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> abs [
	^ self collect: [ :each | each abs ]
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
SysmelPrimitiveVectorType >> dot: other [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> floor [
	^ self collect: [ :each | each floor ]
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

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> sqrt [
	^ self collect: [ :each | each sqrt ]
]

{ #category : #arithmetic }
SysmelPrimitiveVectorType >> with: other collect: aBlock [
	self subclassResponsibility
]
