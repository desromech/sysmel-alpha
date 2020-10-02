Class {
	#name : #GenericComplex,
	#superclass : #GenericLinearAlgebra,
	#instVars : [
		'xy'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #'accessing structure variables' }
GenericComplex class >> angle: theta [
	| c s |
	c := theta cos.
	s := theta sin.
	^ self basicNew
		xy: (self vector2Type x: c y: s);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> identity [
	^ self basicNew
		xy: (self vector2Type x: 1 y: 0);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> one [
	^ self basicNew
		xy: (self vector2Type x: 1 y: 0);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> r: r [
	^ self basicNew
		xy: (self vector2Type x: r y: 0);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> r: r i: i [
	^ self basicNew
		xy: (self vector2Type x: r y: i);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> radius: r angle: theta [
	| c s |
	c := theta cos.
	s := theta sin.
	^ self basicNew
		xy: (self vector2Type x: r*c y: r*s);
		yourself
]

{ #category : #'as yet unclassified' }
GenericComplex class >> typeOfGenericSlotNamed: slotName [
	slotName = #xy ifTrue: [ ^ self vector2Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #'accessing structure variables' }
GenericComplex class >> x: x y: y [
	^ self basicNew
		xy: (self vector2Type x: x y: y);
		yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> xy: v2 [
	^ self basicNew xy: v2; yourself
]

{ #category : #'accessing structure variables' }
GenericComplex class >> zero [
	^ self basicNew
		xy: (self vector2Type x: 0 y: 0);
		yourself
]

{ #category : #comparing }
GenericComplex >> * other [
	| oxy |
	other isNumber ifTrue: [ ^ self class basicNew xy: xy * other; yourself ].
	oxy := other xy.
	^ self class basicNew
		xy: (self class vector2Type
			x: (xy x * oxy x) - (xy y * oxy y)
			y: (xy x * oxy y) + (xy y * oxy x));
		yourself
]

{ #category : #comparing }
GenericComplex >> + other [
	^ self class basicNew xy: xy + other xy
]

{ #category : #comparing }
GenericComplex >> - other [
	^ self class basicNew xy: xy - other xy
]

{ #category : #comparing }
GenericComplex >> / other [
	other isNumber ifTrue: [ ^ self class basicNew xy: xy / other; yourself ].
	^ self * other inverse
]

{ #category : #comparing }
GenericComplex >> < other [
	^ xy < other xy
]

{ #category : #comparing }
GenericComplex >> <= other [
	^ xy <= other xy
]

{ #category : #comparing }
GenericComplex >> <=> other [
	^ xy <=> other xy
]

{ #category : #comparing }
GenericComplex >> = other [
	^ self class == other class and: [ xy = other xy ]
]

{ #category : #comparing }
GenericComplex >> > other [
	^ xy > other xy
]

{ #category : #comparing }
GenericComplex >> >= other [
	^ xy >= other xy
]

{ #category : #comparing }
GenericComplex >> abs [
	^ xy length
]

{ #category : #comparing }
GenericComplex >> angle [
	^ xy y arcTan: xy x
]

{ #category : #comparing }
GenericComplex >> arg [
	^ xy y arcTan: xy x
]

{ #category : #comparing }
GenericComplex >> asFloat32x2x2 [
	^ self asMatrix2x2 castTo: Float32x2x2
]

{ #category : #comparing }
GenericComplex >> asFloat64x2x2 [
	^ self asMatrix2x2 castTo: Float64x2x2
]

{ #category : #comparing }
GenericComplex >> asMatrix2x2 [
	^ self class matrix2x2Type columns: {
		xy.
		self class vector2Type x: xy y negated y: xy x
	}
]

{ #category : #comparing }
GenericComplex >> closeTo: other [
	^ self class == other class and: [ xy closeTo: other xy ]
]

{ #category : #comparing }
GenericComplex >> closeTo: other precision: precision [
	^ self class == other class and: [ xy closeTo: other xy precision: precision ]
]

{ #category : #comparing }
GenericComplex >> conjugated [
	^ self class basicNew
		xy: (self class vector2Type x: xy x y: xy y negated);
		yourself
]

{ #category : #comparing }
GenericComplex >> dot: other [
	^ xy dot: other xy
]

{ #category : #comparing }
GenericComplex >> hash [
	^ xy hash
]

{ #category : #accessing }
GenericComplex >> i [
	^ xy y
]

{ #category : #initialization }
GenericComplex >> initialize [
	xy := self class vector2Type zeros.
]

{ #category : #comparing }
GenericComplex >> inverse [
	^ self class basicNew
		xy: (self class vector2Type x: xy x y: xy y negated) / self length2;
		yourself
]

{ #category : #comparing }
GenericComplex >> length [
	^ xy length
]

{ #category : #comparing }
GenericComplex >> length2 [
	^ xy length2
]

{ #category : #comparing }
GenericComplex >> negated [
	^ self class basicNew
		xy: xy negated;
		yourself
]

{ #category : #accessing }
GenericComplex >> r [
	^ xy x
]

{ #category : #accessing }
GenericComplex >> x [
	^ xy x
]

{ #category : #accessing }
GenericComplex >> xy [
	^ xy
]

{ #category : #accessing }
GenericComplex >> xy: anObject [
	xy := anObject implicitCastTo: self class vector2Type
]

{ #category : #accessing }
GenericComplex >> y [
	^ xy y
]
