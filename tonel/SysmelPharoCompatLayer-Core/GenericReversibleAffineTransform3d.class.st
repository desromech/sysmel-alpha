Class {
	#name : #GenericReversibleAffineTransform3d,
	#superclass : #GenericLinearAlgebra,
	#instVars : [
		'matrix',
		'translation',
		'inverseMatrix',
		'inverseTranslation'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #'instance creation' }
GenericReversibleAffineTransform3d class >> from: eye lookAt: reference up: upVector [
	^ self from: eye lookAtDirection: reference - eye up: upVector.
]

{ #category : #'instance creation' }
GenericReversibleAffineTransform3d class >> from: eye lookAtDirection: direction up: upVector [
	^ self basicNew
		orthonormal: (self matrix3x3Type lookAtDirection: direction normalized up: upVector) translation: eye;
		yourself.
		
]

{ #category : #'instance creation' }
GenericReversibleAffineTransform3d class >> fromInvertibleMatrix4: matrix4 [
	^ self basicNew setInvertibleMatrix4: matrix4; yourself
]

{ #category : #'instance creation' }
GenericReversibleAffineTransform3d class >> identity [
	^ self basicNew setIdentity; yourself
]

{ #category : #testing }
GenericReversibleAffineTransform3d class >> isAbstract [
	^ self == GenericReversibleAffineTransform3d
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d class >> typeOfGenericSlotNamed: slotName [
	slotName = #matrix ifTrue: [ ^ self matrix3x3Type ].
	slotName = #translation ifTrue: [ ^ self vector3Type ].
	slotName = #inverseMatrix ifTrue: [ ^ self matrix3x3Type ].
	slotName = #inverseTranslation ifTrue: [ ^ self vector3Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #comparing }
GenericReversibleAffineTransform3d >> = other [
	^ matrix = other matrix and: [
	translation = other translation and: [
	inverseMatrix = other inverseMatrix and: [
	inverseTranslation = other inverseTranslation ]]]
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> applyMatrix: extraMatrix inverseMatrix: extraMatrixInverse [
	| coercedExtraMatrix coercedExtraMatrixInverse |
	coercedExtraMatrix := extraMatrix implicitCastTo: self class matrix3x3Type.
	coercedExtraMatrixInverse := extraMatrixInverse implicitCastTo: self class matrix3x3Type.
	matrix := coercedExtraMatrix * matrix.
	inverseMatrix := inverseMatrix * coercedExtraMatrixInverse.
	translation := coercedExtraMatrix * translation.
	inverseTranslation := coercedExtraMatrixInverse * inverseTranslation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> applyOrthonormalMatrix: orthonormal [
	^ self applyMatrix: orthonormal inverseMatrix: orthonormal transpose
]

{ #category : #converting }
GenericReversibleAffineTransform3d >> asDecomposedTransform3d [	
	^ self class decomposedTransform3dType basicNew
		matrix: self matrix;
		translation: self translation;
		yourself
]

{ #category : #converting }
GenericReversibleAffineTransform3d >> asReversibleAffineTransform3d [
	^ self
]

{ #category : #converting }
GenericReversibleAffineTransform3d >> asReversibleAffineTransform3dF32 [
	^ ReversibleAffineTransform3dF32 basicNew matrix: matrix asFloat32x3x3 inverseMatrix: inverseMatrix asFloat32x3x3 translation: translation asFloat32x3
]

{ #category : #converting }
GenericReversibleAffineTransform3d >> asReversibleAffineTransform3dF64 [
	^ ReversibleAffineTransform3dF64 basicNew matrix: matrix asFloat64x3x3 inverseMatrix: inverseMatrix asFloat64x3x3 translation: translation asFloat64x3
]

{ #category : #comparing }
GenericReversibleAffineTransform3d >> hash [
	^ matrix hash bitXor: (
	translation hash bitXor: (
	inverseMatrix hash bitXor: inverseTranslation hash))
]

{ #category : #initialization }
GenericReversibleAffineTransform3d >> initialize [
	matrix := self class matrix3x3Type zeros.
	inverseMatrix := self class matrix3x3Type zeros.
	translation := self class vector3Type zeros.
	inverseTranslation := self class vector3Type zeros.
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> inverse [
	^ self class basicNew
		matrix: inverseMatrix inverseMatrix: matrix translation: inverseTranslation
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> inverseMatrix [
	^ inverseMatrix
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> inverseMatrix4 [
	^ self class matrix4x4Type mat3: inverseMatrix translation: inverseTranslation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> inverseTransformPosition: aVector3 [
	^ inverseMatrix * aVector3 + inverseTranslation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> inverseTransformTransform: transform [
	^ self class new
		matrix: inverseMatrix * transform matrix
			inverseMatrix: transform inverseMatrix * matrix
			translation: inverseTranslation + (inverseMatrix * transform translation);
		yourself.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> inverseTransformVector: aVector3 [
	^ inverseMatrix * aVector3
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> inverseTranslation [
	^ inverseTranslation
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> inverseTranslation4 [
	^ self class vector4Type xyz: inverseTranslation w: 1
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> isIdentity [
	^ matrix isIdentity and: [ translation isZeros ]
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtBack [
	self orthonormal: self class matrix3x3Type lookAtBack
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtBottom [
	self orthonormal: self class matrix3x3Type lookAtBottom
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtFront [
	self orthonormal: self class matrix3x3Type lookAtFront
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtLeft [
	self orthonormal: self class matrix3x3Type lookAtLeft
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtRight [
	self orthonormal: self class matrix3x3Type lookAtRight
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> lookAtTop [
	self orthonormal: self class matrix3x3Type lookAtTop
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> matrix [
	^ matrix
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> matrix4 [
	^ self class matrix4x4Type mat3: matrix translation: translation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> matrix4: matrix4 inverseMatrix4: inverseMatrix4 [
	matrix := matrix4 topLeft3x3 implicitCastTo: self class matrix3x3Type.
	translation := matrix4 fourthColumn xyz implicitCastTo: self class vector3Type.

	inverseMatrix := inverseMatrix4 topLeft3x3 implicitCastTo: self class matrix3x3Type.
	inverseTranslation := inverseMatrix4 fourthColumn xyz implicitCastTo: self class vector3Type.
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> matrix: newMatrix inverseMatrix: newInverseMatrix translation: newTranslation [
	matrix := newMatrix implicitCastTo: self class matrix3x3Type.
	inverseMatrix := newInverseMatrix implicitCastTo: self class matrix3x3Type.
	translation := newTranslation implicitCastTo: self class vector3Type.
	inverseTranslation := inverseMatrix * translation negated
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> maxScaleFactor [
	^ (self matrix firstColumn length max: matrix secondColumn length) max: matrix thirdColumn length
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> orthonormal: newMatrix [
	matrix := newMatrix implicitCastTo: self class matrix3x3Type.
	inverseMatrix := matrix transpose.
	
	"Recompute the inverse translation."
	inverseTranslation := inverseMatrix * translation negated.
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> orthonormal: newMatrix translation: newTranslation [
	self matrix: newMatrix inverseMatrix: newMatrix transpose translation: newTranslation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateDegreesOnX: x [
	self rotateRadiansOnX: x degreesToRadians.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateDegreesOnY: y [
	self rotateRadiansOnY: y degreesToRadians.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateDegreesOnZ: z [
	self rotateRadiansOnZ: z degreesToRadians.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateDegreesOnZ: z y: y x: x [
	self rotateRadiansOnZ: z degreesToRadians y: y degreesToRadians x: x degreesToRadians
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateRadiansOnX: x [
	self applyOrthonormalMatrix: (self class matrix3x3Type xRotation: x).
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateRadiansOnY: y [
	self applyOrthonormalMatrix: (self class matrix3x3Type yRotation: y).
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateRadiansOnZ: z [
	self applyOrthonormalMatrix: (self class matrix3x3Type zRotation: z).
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> rotateRadiansOnZ: z y: y x: x [
	self applyOrthonormalMatrix: (self class matrix3x3Type zyxRotation: (self class vector3Type x: z y: x z: y)).
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> scale [
	^ self class vector3Type x: matrix firstColumn length y: matrix secondColumn length z: matrix thirdColumn length
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> scaleBy: scale [
	self applyMatrix: (self class matrix3x3Type scale: scale) inverseMatrix: (self class matrix3x3Type scale: 1 / scale).
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> scaleByX: x y: y z: z [
	self scaleBy: (self class vector3Type x: x y: y z: z)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> setForBox: aBox [
	self setIdentity;
		scaleBy: aBox extent;
		translateTo: aBox center
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> setIdentity [
	matrix := self class matrix3x3Type identity.
	translation := self class vector3Type zeros.
	inverseMatrix := self class matrix3x3Type identity.
	inverseTranslation := self class vector3Type zeros.
	
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> setInvertibleMatrix4: matrix4 [
	self matrix4: matrix4 inverseMatrix4: matrix4 inverse
]

{ #category : #'memory access' }
GenericReversibleAffineTransform3d >> storeBytesIn: aByteArray position: byteArrayPosition [
	| matrix4 |
	matrix4 := self matrix4.
	matrix4 storeBytesIn: aByteArray position: byteArrayPosition.
	self inverseMatrix4 storeBytesIn: aByteArray position: byteArrayPosition + matrix4 class instanceSize.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> transformNormal: aVector3 [
	^ inverseMatrix transpose * aVector3
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> transformPosition: aPosition [
	^ (matrix*aPosition) + translation
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> transformTransform: transform [
	^ self class new
		matrix: matrix * transform matrix
			inverseMatrix: transform inverseMatrix * inverseMatrix
		translation: self translation + (matrix * transform translation);
		yourself.
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> transformVector: aVector [
	^ matrix*aVector
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateBy: vector3 [
	self translation: translation  + vector3
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateByX: x [
	self translateBy: (self class vector3Type x: x y: 0 z: 0)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateByX: x y: y z: z [
	self translateBy: (self class vector3Type x: x y: y z: z)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateByY: y [
	self translateBy: (self class vector3Type x: 0 y: y z: 0)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateByZ: z [
	self translateBy: (self class vector3Type x: 0 y: 0 z: z)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateTo: vector3 [
	self translation: vector3
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateToX: x [
	self translation: (self class vector3Type x: x y: 0 z: 0)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateToX: x y: y z: z [
	self translation: (self class vector3Type x: x y: y z: z)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateToY: y [
	self translation: (self class vector3Type x: 0 y: y z: 0)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translateToZ: z [
	self translation: (self class vector3Type x: 0 y: 0 z: z)
]

{ #category : #'as yet unclassified' }
GenericReversibleAffineTransform3d >> translation [
	^ translation
]

{ #category : #accessing }
GenericReversibleAffineTransform3d >> translation4 [
	^ self class vector4Type xyz: translation w: 1
]

{ #category : #testing }
GenericReversibleAffineTransform3d >> translation: newTranslation [
	translation := newTranslation implicitCastTo: self class vector3Type.
	inverseTranslation := inverseMatrix * translation negated.
]
