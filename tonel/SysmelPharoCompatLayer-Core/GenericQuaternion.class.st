Class {
	#name : #GenericQuaternion,
	#superclass : #GenericLinearAlgebra,
	#instVars : [
		'xyzw'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #accessing }
GenericQuaternion class >> axis: axis angle: angle [
	| halfAngle c s |
	halfAngle := angle / 2.
	c := halfAngle cos.
	s := halfAngle sin.
	^ self basicNew xyzw: (self vector4Type xyz: axis*s w: c); yourself
]

{ #category : #accessing }
GenericQuaternion class >> identity [
	^ self xyzw: (self vector4Type x: 0 y: 0 z: 0 w: 1)
]

{ #category : #accessing }
GenericQuaternion class >> one [
	^ self xyzw: (self vector4Type x: 0 y: 0 z: 0 w: 1)
]

{ #category : #accessing }
GenericQuaternion class >> r: r [
	^ self xyzw: (self vector4Type x: 0 y: 0 z: 0 w: r)
]

{ #category : #accessing }
GenericQuaternion class >> r: r i: i j: j k: k [
	^ self xyzw: (self vector4Type x: i y: j z: k w: r)
]

{ #category : #accessing }
GenericQuaternion class >> x: x y: y z: z w: w [
	^ self xyzw: (self vector4Type x: x y: y z: z w: w)
]

{ #category : #accessing }
GenericQuaternion class >> xRotation: angle [
	| halfAngle c s |
	halfAngle := angle / 2.
	c := halfAngle cos.
	s := halfAngle sin.
	^ self basicNew xyzw: (self vector4Type x: s y: 0 z: 0 w: c); yourself
]

{ #category : #accessing }
GenericQuaternion class >> xyzRotation: angles [
	^ (self xRotation: angles x) * (self yRotation: angles y) * (self zRotation: angles z)
]

{ #category : #accessing }
GenericQuaternion class >> xyzw: v4 [
	^ self basicNew xyzw: v4; yourself
]

{ #category : #accessing }
GenericQuaternion class >> yRotation: angle [
	| halfAngle c s |
	halfAngle := angle / 2.
	c := halfAngle cos.
	s := halfAngle sin.
	^ self basicNew xyzw: (self vector4Type x: 0 y: s z: 0 w: c); yourself
]

{ #category : #accessing }
GenericQuaternion class >> zRotation: angle [
	| halfAngle c s |
	halfAngle := angle / 2.
	c := halfAngle cos.
	s := halfAngle sin.
	^ self basicNew xyzw: (self vector4Type x: 0 y: 0 z: s w: c); yourself
]

{ #category : #accessing }
GenericQuaternion class >> zero [
	^ self xyzw: (self vector4Type x: 0 y: 0 z: 0 w: 0)
]

{ #category : #accessing }
GenericQuaternion class >> zyxRotation: angles [
	^ (self zRotation: angles z) * (self yRotation: angles y) * (self xRotation: angles x)
]

{ #category : #comparing }
GenericQuaternion >> * other [
	other isNumber ifTrue: [ ^ self class basicNew xyzw: xyzw * other ].
	^ self class
		r: (self r * other r) - (self i * other i) - (self j * other j) - (self k * other k)
		i: (self r * other i) + (self i * other r) + (self j * other k) - (self k * other j)
		j: (self r * other j) - (self i * other k) + (self j * other r) + (self k * other i)
		k: (self r * other k) + (self i * other j) - (self j * other i) + (self k * other r)
]

{ #category : #comparing }
GenericQuaternion >> + other [
	^ self class basicNew xyzw: xyzw + other xyzw
]

{ #category : #comparing }
GenericQuaternion >> - other [
	^ self class basicNew xyzw: xyzw - other xyzw
]

{ #category : #comparing }
GenericQuaternion >> / other [
	other isNumber ifTrue: [ ^ self class basicNew xyzw: xyzw / other ].
	^ self * other inverse
]

{ #category : #comparing }
GenericQuaternion >> < other [
	^ xyzw < other xyzw
]

{ #category : #comparing }
GenericQuaternion >> <= other [
	^ xyzw <= other xyzw
]

{ #category : #comparing }
GenericQuaternion >> <=> other [
	^ xyzw <=> other xyzw
]

{ #category : #comparing }
GenericQuaternion >> = other [
	^ self class == other class and: [ xyzw = other xyzw ]
]

{ #category : #comparing }
GenericQuaternion >> > other [
	^ xyzw > other xyzw
]

{ #category : #comparing }
GenericQuaternion >> >= other [
	^ xyzw >= other xyzw
]

{ #category : #comparing }
GenericQuaternion >> abs [
	^ xyzw length
]

{ #category : #comparing }
GenericQuaternion >> asFloat32x3x3 [
	^ self asMatrix3x3 castTo: Float32x3x3
]

{ #category : #comparing }
GenericQuaternion >> asFloat64x3x3 [
	^ self asMatrix3x3 castTo: Float64x3x3
]

{ #category : #comparing }
GenericQuaternion >> asMatrix3x3 [
	| r i j k |
	r := self r.
	i := self i.
	j := self j.
	k := self k.
	^ self class matrix3x3Type rows: {
		1.0 - (2.0*j*j) - (2.0*k*k).
		(2.0*i*j) - (2.0*k*r).
		(2.0*i*k) + (2.0*j*r).

		(2.0*i*j) + (2.0*k*r).
		1.0 - (2.0*i*i) - (2.0*k*k).
		(2.0*j*k) - (2.0*i*r).

		(2.0*i*k) - (2.0*j*r).
		(2.0*j*k) + (2.0*i*r).
		1.0 - (2.0*i*i) - (2.0*j*j)
	}
]

{ #category : #comparing }
GenericQuaternion >> closeTo: other [
	^ self class == other class and: [ xyzw closeTo: other xyzw ]
]

{ #category : #comparing }
GenericQuaternion >> closeTo: other precision: precision [
	^ self class == other class and: [ xyzw closeTo: other xyzw precision: precision ]
]

{ #category : #comparing }
GenericQuaternion >> conjugated [
	^ self class basicNew
		xyzw: (self class vector4Type x: xyzw x negated y: xyzw y negated z: xyzw z negated w: xyzw w);
		yourself
]

{ #category : #comparing }
GenericQuaternion >> dot: other [
	^ xyzw dot: other xyzw
]

{ #category : #comparing }
GenericQuaternion >> hash [
	^ xyzw hash
]

{ #category : #accessing }
GenericQuaternion >> i [
	^ xyzw x
]

{ #category : #accessing }
GenericQuaternion >> ijkr [
	^ xyzw
]

{ #category : #comparing }
GenericQuaternion >> inverse [
	^ self class basicNew
		xyzw: (self class vector4Type x: xyzw x negated y: xyzw y negated z: xyzw z negated w: xyzw w) / xyzw length2;
		yourself
]

{ #category : #accessing }
GenericQuaternion >> j [
	^ xyzw y
]

{ #category : #accessing }
GenericQuaternion >> k [
	^ xyzw z
]

{ #category : #comparing }
GenericQuaternion >> length [
	^ xyzw length
]

{ #category : #comparing }
GenericQuaternion >> length2 [
	^ xyzw length2
]

{ #category : #comparing }
GenericQuaternion >> negated [
	^ self class basicNew xyzw: xyzw negated; yourself
]

{ #category : #accessing }
GenericQuaternion >> r [
	^ xyzw w
]

{ #category : #accessing }
GenericQuaternion >> rijk [
	^ xyzw wxyz
]

{ #category : #accessing }
GenericQuaternion >> w [
	^ xyzw w
]

{ #category : #accessing }
GenericQuaternion >> x [
	^ xyzw x
]

{ #category : #accessing }
GenericQuaternion >> xyz [
	^ xyzw xyz
]

{ #category : #accessing }
GenericQuaternion >> xyzw [
	^ xyzw
]

{ #category : #accessing }
GenericQuaternion >> xyzw: anObject [
	xyzw := anObject implicitCastTo: self class vector4Type
]

{ #category : #accessing }
GenericQuaternion >> y [
	^ xyzw y
]

{ #category : #accessing }
GenericQuaternion >> z [
	^ xyzw z
]
