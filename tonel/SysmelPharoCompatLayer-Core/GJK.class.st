Class {
	#name : #GJK,
	#superclass : #Object,
	#classVars : [
		'Epsilon',
		'Epsilon2',
		'MaxNumberOfIterations',
		'Origin'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #'as yet unclassified' }
GJK class >> closestPointToOriginInSimplex: simplex [
	simplex size = 1 ifTrue: [
		^ simplex first
	].
	simplex size = 2 ifTrue: [
		^ (Geometry closestPointInLine: simplex to: Origin)
	].
	simplex size = 3 ifTrue: [
		^ (Geometry closestPointInTriangle3D: simplex to: Origin)
	].

	self assert: simplex size = 4.
	^ (Geometry closestPointInTetrahedron: simplex to: Origin)
]

{ #category : #'as yet unclassified' }
GJK class >> distanceFor: support [
	| lastPoint simplex nextDirection remainingIterations |
	lastPoint := support value: (Float32x3 x: -1).
	simplex := { lastPoint }.
	nextDirection := lastPoint negated.
	
	remainingIterations := MaxNumberOfIterations.
	[remainingIterations > 0 ] whileTrue: [
		| nextPoint closesPointToOrigin | 
		nextPoint := support value: nextDirection.
		(nextPoint - lastPoint dot: nextDirection ) <= Epsilon ifTrue: [ 
			^ lastPoint length
		].
		simplex := self insertPoint: nextPoint inSimplex: simplex.
		lastPoint := nextPoint.
		
		closesPointToOrigin := self closestPointToOriginInSimplex: simplex.
		(closesPointToOrigin - Origin) length2 < Epsilon2 ifTrue: [
			^ 0.0
		].
	
		nextDirection := closesPointToOrigin negated
	].

	^ lastPoint length
]

{ #category : #'as yet unclassified' }
GJK class >> distanceFrom: firstSupportFunction to: secondSupportFunction [
	^ self distanceFor: [ :direction | (firstSupportFunction value: direction) - (secondSupportFunction value: direction negated) ].
]

{ #category : #'class initialization' }
GJK class >> initialize [
	Origin := Float32x3 zeros.
	MaxNumberOfIterations := 32.
	Epsilon := 0.00001.
	Epsilon2 := Epsilon*Epsilon.
]

{ #category : #'as yet unclassified' }
GJK class >> insertPoint: newPoint inSimplex: simplex [
	simplex size = 1 ifTrue: [
		self assert: (newPoint closeTo: simplex first) not.
		^ {simplex first . newPoint }
	].

	simplex size = 2 ifTrue: [ 
		self assert: (newPoint closeTo: simplex first) not.
		(Geometry isPoint3DCollinear: simplex first with: simplex second with: newPoint) ifTrue: [
			^ {simplex second . newPoint }
		] ifFalse: [ 
			^ {simplex first . simplex second . newPoint }
		]
	].

	simplex size = 3 ifTrue: [
		(Geometry isPoint3DCoplanar: simplex first with: simplex second with: simplex third with: newPoint) ifTrue: [
			^ {simplex second . simplex third . newPoint }
		] ifFalse: [ 
			^ {simplex first . simplex second . simplex third . newPoint }
		].
	].

	self assert: simplex size = 4.
	^ {simplex second . simplex third . simplex fourth . newPoint }
]

{ #category : #'as yet unclassified' }
GJK class >> insertPointMaybeRepeated: newPoint inSimplex: simplex [
	(simplex anySatisfy: [ :each | each closeTo: newPoint ]) ifTrue: [ ^ simplex ].
	
	simplex size = 0 ifTrue: [
		^ {newPoint}
	].
	simplex size = 1 ifTrue: [
		^ {simplex first . newPoint }
	].
	simplex size = 2 ifTrue: [ 
		(Geometry isPoint3DCollinear: simplex first with: simplex second with: newPoint) ifTrue: [
			^ {simplex second . newPoint }
		] ifFalse: [ 
			^ {simplex first . simplex second . newPoint }
		]
	].
	simplex size = 3 ifTrue: [
		(Geometry isPoint3DCoplanar: simplex first with: simplex second with: simplex third with: newPoint) ifTrue: [
			^ {simplex second . simplex third . newPoint }
		] ifFalse: [ 
			^ {simplex first . simplex second . simplex third . newPoint }
		].
	].

	self assert: simplex size = 4.
	^ {simplex second . simplex third . simplex fourth . newPoint }
]

{ #category : #'as yet unclassified' }
GJK class >> ray: ray castFor: support [
	"Algorithm from 'Ray Casting against General Convex Objectswith Application to Continuous CollisionDetection' by G. Van Den Bergen."
	| lambda x s r n v simplex remainingIterations |
	lambda := ray tmin.
	s := ray origin.
	r := ray direction.
	x := s + (r * lambda).
	n := Float32x3 zeros.
	v := x - (support value: ray direction negated).
	simplex := #().
	remainingIterations := MaxNumberOfIterations.
	[ remainingIterations > 0 and: [v length2 > Epsilon2] ] whileTrue: [
		| w |
		lambda > ray tmax ifTrue: [ ^ nil ].

		w := x - (support value: v).
		(v dot: w) > 0 ifTrue: [
			(v dot: r) >= Epsilon2 negated ifTrue: [ ^ nil ].
			lambda := lambda - ((v dot: w) / (v dot: r)).
			x := s + (r * lambda).
			n := v.
			w := x - (support value: v).
		].
	
		simplex := self insertPointMaybeRepeated: w inSimplex: simplex.
		v := self closestPointToOriginInSimplex: simplex.
		remainingIterations := remainingIterations - 1
	].

	 ^ {lambda . n }
]

{ #category : #'as yet unclassified' }
GJK class >> testIntersectionBetween: firstSupportFunction and: secondSupportFunction [
	^ (self distanceFrom: firstSupportFunction to: secondSupportFunction) closeTo: 0.0
]

{ #category : #'as yet unclassified' }
GJK class >> testIntersectionFor: supportFunction [
	^ (self distanceFor: supportFunction) closeTo: 0.0
]
