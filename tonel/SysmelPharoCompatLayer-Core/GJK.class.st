Class {
	#name : #GJK,
	#superclass : #Object,
	#classVars : [
		'Origin'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #'as yet unclassified' }
GJK class >> closetPointToOriginInSimplex: simplex [
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
	| lastPoint simplex nextDirection |
	lastPoint := support value: (Float32x3 x: -1).
	simplex := { lastPoint }.
	nextDirection := lastPoint negated.
	
	[
		| nextPoint closesPointToOrigin | 
		nextPoint := support value: nextDirection.
		(nextPoint - lastPoint dot: nextDirection ) <= 0 ifTrue: [ 
			^ lastPoint length
		].
		simplex := self insertPoint: nextPoint inSimplex: simplex.
		lastPoint := nextPoint.
		
		closesPointToOrigin := self closetPointToOriginInSimplex: simplex.
		(closesPointToOrigin closeTo: Origin) ifTrue: [
			^ 0.0
		].
	
		nextDirection := closesPointToOrigin negated
	] repeat.
]

{ #category : #'as yet unclassified' }
GJK class >> distanceFrom: firstSupportFunction to: secondSupportFunction [
	^ self distanceFor: [ :direction | (firstSupportFunction value: direction) - (secondSupportFunction value: direction negated) ].
]

{ #category : #'class initialization' }
GJK class >> initialize [
	Origin := Float32x3 zeros.
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
GJK class >> testIntersectionBetween: firstSupportFunction and: secondSupportFunction [
	^ (self distanceFrom: firstSupportFunction to: secondSupportFunction) closeTo: 0.0
]

{ #category : #'as yet unclassified' }
GJK class >> testIntersectionFor: supportFunction [
	^ (self distanceFor: supportFunction) closeTo: 0.0
]
