"
A GeometryTest is a test class for testing the behavior of Geometry
"
Class {
	#name : #GeometryTest,
	#superclass : #TestCase,
	#category : #'SysmelPharoCompatLayer-Core-Tests-Math-Geometry'
}

{ #category : #tests }
GeometryTest >> testClosestPointInLine [
	| line |
	line := { Float32x3 zeros . (Float32x3 x: 1.0) }.
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: 0.5 y: 1.0)) equals: (Float32x3 x: 0.5).
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: -0.5 y: 1.0)) equals: (Float32x3 x: 0.0).
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: 20.5 y: 1.0)) equals: (Float32x3 x: 1.0).
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: 0.5 y: -1.0)) equals: (Float32x3 x: 0.5).
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: -0.5 y: -1.0)) equals: (Float32x3 x: 0.0).
	self assert: (Geometry closestPointInLine: line to: (Float32x3 x: 20.5 y: -1.0)) equals: (Float32x3 x: 1.0).
]

{ #category : #tests }
GeometryTest >> testClosestPointInTetrahedron [
	| tetrahedron |
	tetrahedron := { Float32x3 zeros . (Float32x3 x: 1.0) . (Float32x3 y: 1.0) . (Float32x3 z: 1.0)}.

	"Bottom triangle test."
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: Float32x3 zeros) equals: Float32x3 zeros.
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 x: 1.0)) equals: (Float32x3 x: 1.0).
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 y: 1.0)) equals: (Float32x3 y: 1.0).
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 x: 0.5 y: 0.5)) equals: (Float32x3 x: 0.5 y: 0.5).
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 x: 0.5 y: -0.5)) equals: (Float32x3 x: 0.5).
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 x: -0.5 y: 0.5)) equals: (Float32x3 y: 0.5).
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: Float32x3 ones) closeTo: Float32x3 ones /3.
	
	"Other tests."
	self assert: (Geometry closestPointInTetrahedron: tetrahedron to: (Float32x3 x: 0.25 y: 0.25 z: 0.25)) equals: (Float32x3 x: 0.25 y: 0.25 z: 0.25).

]

{ #category : #tests }
GeometryTest >> testClosestPointInTriangle [
	| triangle |
	triangle := { Float32x3 zeros . (Float32x3 x: 1.0) . (Float32x3 y: 1.0) }.
	self assert: (Geometry closestPointInTriangle3D: triangle to: Float32x3 zeros) equals: Float32x3 zeros.
	self assert: (Geometry closestPointInTriangle3D: triangle to: (Float32x3 x: 1.0)) equals: (Float32x3 x: 1.0).
	self assert: (Geometry closestPointInTriangle3D: triangle to: (Float32x3 y: 1.0)) equals: (Float32x3 y: 1.0).
	self assert: (Geometry closestPointInTriangle3D: triangle to: (Float32x3 x: 0.5 y: 0.5)) equals: (Float32x3 x: 0.5 y: 0.5).
	self assert: (Geometry closestPointInTriangle3D: triangle to: (Float32x3 x: 0.5 y: -0.5)) equals: (Float32x3 x: 0.5).
	self assert: (Geometry closestPointInTriangle3D: triangle to: (Float32x3 x: -0.5 y: 0.5)) equals: (Float32x3 y: 0.5).
	self assert: (Geometry closestPointInTriangle3D: triangle to: Float32x3 ones) equals: (Float32x3 x: 0.5 y: 0.5).

]

{ #category : #tests }
GeometryTest >> testCollinearPoints3D [
	self assert: (Geometry isPoint3DCollinear: Float32x3 zeros with: Float32x3 zeros with: Float32x3 zeros).
	self assert: (Geometry isPoint3DCollinear: Float32x3 ones with: Float32x3 ones with: Float32x3 ones).
	self assert: (Geometry isPoint3DCollinear: Float32x3 zeros with: Float32x3 ones with: Float32x3 ones).
	self assert: (Geometry isPoint3DCollinear: Float32x3 ones with: Float32x3 zeros with: Float32x3 ones).
	self assert: (Geometry isPoint3DCollinear: Float32x3 ones with: Float32x3 ones with: Float32x3 zeros ).
	self assert: (Geometry isPoint3DCollinear: (Float32x3 x: 1) with: Float32x3 zeros with: (Float32x3 x: 20)).
	self assert: (Geometry isPoint3DCollinear: Float32x3 ones with: Float32x3 ones*2 with: Float32x3 ones*2).
	self deny: (Geometry isPoint3DCollinear: Float32x3 zeros with: Float32x3 ones with: (Float32x3 y: 1.0)).
]

{ #category : #tests }
GeometryTest >> testCoplanarPoints3D [
	self assert: (Geometry isPoint3DCoplanar: Float32x3 ones with: Float32x3 ones with: Float32x3 ones with: Float32x3 ones).
	self assert: (Geometry isPoint3DCoplanar: Float32x3 zeros with: Float32x3 ones with: Float32x3 ones *2 with: Float32x3 ones).
	self assert: (Geometry isPoint3DCoplanar: Float32x3 zeros with: (Float32x3 x: 1.0) with: (Float32x3 x: 1.0 y: 1.0) with: (Float32x3 y: 1.0)).
	self deny: (Geometry isPoint3DCoplanar: Float32x3 zeros with: (Float32x3 x: 1.0) with: Float32x3 ones with: (Float32x3 y: 1.0)).

]
