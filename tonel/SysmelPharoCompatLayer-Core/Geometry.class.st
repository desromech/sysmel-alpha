Class {
	#name : #Geometry,
	#superclass : #Object,
	#instVars : [
		'simplex',
		'nextDirection'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInLine: line to: targetPoint [
	^ self closestPointInLineFrom: line first to: line second to: targetPoint
]

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInLineFrom: a to: b to: targetPoint [
	| delta lambda |	
	delta := b - a.
	lambda := (targetPoint - a dot: delta) / delta length2.
	lambda := lambda min: 1.0 max: 0.0.
	^ a + (delta*lambda)
]

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInTetrahedron: tetrahedron to: point [
	^ self closestPointInTetrahedronA: tetrahedron first B: tetrahedron second C: tetrahedron third D: tetrahedron fourth to: point
]

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInTetrahedronA: a B: b C: c D: d to: point [
	| p1 |
	
	p1 := PlaneF32 point: a point: b point: c.
	(p1 isBehind: d) ifTrue: [
		^ self closestPointInTetrahedronA: a B: b C: c D: d to: point
	] ifFalse: [
		^ self closestPointInTetrahedronA: b B: a C: c D: d to: point
	].
]

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInTriangle3D: triangle to: p [
	^ self closestPointInTriangle3DA: triangle first B: triangle second C: triangle third to: p
]

{ #category : #'as yet unclassified' }
Geometry class >> closestPointInTriangle3DA: a B: b C: c to: p [
	"Algorithm from 'Real Time Collision detection' by Ericson. ClosestPtPointTriangle."
	| snom sdenom tnom tdenom unom udenom n vc va vb u v w |

	"P on AB."
	snom := p - a dot: b - a.
	sdenom := p - b dot: a - b.
	
	"P on AC."
	tnom := p - a dot: c - a.
	tdenom := p - c dot: a - c.
	
	"Check the vertex region."
	(snom <= 0.0 and: [ tnom <= 0.0 ]) ifTrue: [ ^ a ].
	
	"P on BC"
	unom := p - b dot: c - b.
	udenom := p - c dot: b - c.
	(sdenom <= 0.0 and: [ unom <= 0.0 ]) ifTrue: [ ^ b ].
	(tdenom <= 0.0 and: [ udenom <= 0.0 ]) ifTrue: [ ^ c ].
	
	n := b - a cross: c - a.
	
	vc := n dot: (a - p cross: b - p).
	(vc <= 0.0 and: [ snom >= 0.0 and: [sdenom >= 0.0 ] ]) ifTrue: [ 
		^ a + (snom / (snom + sdenom) * (b - a))
	].

	va := n dot: (b - p cross: c - p).
	(va <= 0.0 and: [ unom >= 0.0 and: [udenom >= 0.0 ] ]) ifTrue: [ 
		^ b + (unom / (unom + udenom) * (c - b))	
	].

	vb := n dot: (c - p cross: a - p).
	(vb <= 0.0 and: [ tnom >= 0.0 and: [tdenom >= 0.0 ] ]) ifTrue: [ 
		^ a + (tnom / (tnom + tdenom) * (c - a))
	].
	
	u := va / (va + vb + vc).
	v := vb / (va + vb + vc).
	w := 1.0 - u - v.

	^ (a*u) + (b*v) + (c*w)
]

{ #category : #private }
Geometry class >> doClosestPointInTetrahedronA: a B: b C: c D: d to: point [
	| p1 p2 p3 p4 |
	
	p1 := PlaneF32 point: a point: b point: c.
	(p1 isInFrontOrInside: point) ifTrue: [ ^ self closestPointInTriangle3D: { a . b . c } to: point ].

	p2 := PlaneF32 point: b point: a point: d.
	(p2 isInFrontOrInside: point) ifTrue: [ ^ self closestPointInTriangle3D: { b . a . d } to: point ].

	p3 := PlaneF32 point: a point: c point: d.
	(p3 isInFrontOrInside: point) ifTrue: [ ^ self closestPointInTriangle3D: { a . c . d } to: point ].

	p4 := PlaneF32 point: c point: b point: d.
	(p4 isInFrontOrInside: point) ifTrue: [ ^ self closestPointInTriangle3D: { c . b . d } to: point ].

	"The point itself is in the tetrahedron."
	^ point

]

{ #category : #testing }
Geometry class >> isPoint3DCollinear: first with: second with: third [
	| u v |
	u := second - first.
	v := third - first.
	^ (u cross: v) length2 closeTo: 0.0
]

{ #category : #testing }
Geometry class >> isPoint3DCoplanar: first with: second with: third with: fourth [
	"Algorithm from: http://www.ambrsoft.com/TrigoCalc/Plan3D/PointsCoplanar.htm"
	| v1 v2 v3 |
	v1 := second - first.
	v2 := third - first.	
	v3 := fourth - first.
	^ (v1 dot: (v2 cross: v3)) closeTo: 0.0
]
