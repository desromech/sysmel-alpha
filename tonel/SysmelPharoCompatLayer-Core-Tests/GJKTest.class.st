"
A GJKTest is a test class for testing the behavior of GJK
"
Class {
	#name : #GJKTest,
	#superclass : #TestCase,
	#category : #'SysmelPharoCompatLayer-Core-Tests-Math-Geometry'
}

{ #category : #tests }
GJKTest >> testSphereSphereDistance [
	| firstShape secondShape |
	firstShape := SphereF32 new
		center: (Float32x3 x: -2.0);
		radius: 1.0;
		yourself.
	secondShape := SphereF32 new
		center: (Float32x3 x: 2.0);
		radius: 1.0;
		yourself.
	self assert: (GJK distanceFrom: firstShape supportFunction to: secondShape supportFunction) closeTo: (firstShape distanceWithSphere: secondShape).
]

{ #category : #tests }
GJKTest >> testSphereSphereDistance2 [
	| firstShape secondShape |
	firstShape := SphereF32 new
		center: (Float32x3 x: -2.0);
		radius: 1.0;
		yourself.
	secondShape := SphereF32 new
		center: (Float32x3 x: 2.0 y: 1.0);
		radius: 1.0;
		yourself.
	self assert: (GJK distanceFrom: firstShape supportFunction to: secondShape supportFunction) closeTo: (firstShape distanceWithSphere: secondShape).
]

{ #category : #tests }
GJKTest >> testSphereSphereDistance3 [
	| firstShape secondShape |
	firstShape := SphereF32 new
		center: (Float32x3 x: -2.0);
		radius: 1.0;
		yourself.
	secondShape := SphereF32 new
		center: (Float32x3 x: 2.0 y: 1.0 z: 25.0);
		radius: 1.0;
		yourself.
	self assert: (GJK distanceFrom: firstShape supportFunction to: secondShape supportFunction) closeTo: (firstShape distanceWithSphere: secondShape).
]
