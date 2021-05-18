Class {
	#name : #GenericDecomposedTransform3d,
	#superclass : #GenericLinearAlgebra,
	#instVars : [
		'scale',
		'rotation',
		'translation'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #testing }
GenericDecomposedTransform3d class >> identity [
	^ self basicNew setIdentity
]

{ #category : #testing }
GenericDecomposedTransform3d class >> typeOfGenericSlotNamed: slotName [
	slotName = #scale ifTrue: [ ^ self vector3Type ].
	slotName = #rotation ifTrue: [ ^ self quaternionType ].
	slotName = #translation ifTrue: [ ^ self vector3Type ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #converting }
GenericDecomposedTransform3d >> asDecomposedTransform3d [
	^ self
]

{ #category : #converting }
GenericDecomposedTransform3d >> asReversibleAffineTransform3d [
	^ self class reversibleAffineTransform3dType new
		matrix: self matrix inverseMatrix: self inverseMatrix translation: self translation;
		yourself
]

{ #category : #initialization }
GenericDecomposedTransform3d >> initialize [
	self setIdentity
]

{ #category : #accessing }
GenericDecomposedTransform3d >> inverseMatrix [
	^ (self class matrix3x3Type scale: self inverseScale) * rotation conjugated asMatrix3x3
]

{ #category : #accessing }
GenericDecomposedTransform3d >> inverseScale [
	^ self class vector3Type ones / scale
]

{ #category : #converting }
GenericDecomposedTransform3d >> inverseTranslation [
	^ translation negated
]

{ #category : #accessing }
GenericDecomposedTransform3d >> matrix [
	^ rotation asMatrix3x3 * (self class matrix3x3Type scale: scale)
]

{ #category : #accessing }
GenericDecomposedTransform3d >> matrix: aMatrix [
	scale := self class vector3Type
		x: aMatrix firstColumn length
		y: aMatrix secondColumn length
		z: aMatrix thirdColumn length.
	rotation := self class matrix3x3Type basicNew
		firstColumn: aMatrix firstColumn / scale x;
		secondColumn: aMatrix secondColumn / scale y;
		thirdColumn: aMatrix thirdColumn / scale z;
		asQuaternion
]

{ #category : #accessing }
GenericDecomposedTransform3d >> rotation [

	^ rotation
]

{ #category : #accessing }
GenericDecomposedTransform3d >> rotation: anObject [
	rotation := anObject implicitCastTo: self class quaternionType
]

{ #category : #accessing }
GenericDecomposedTransform3d >> scale [

	^ scale
]

{ #category : #accessing }
GenericDecomposedTransform3d >> scale: anObject [

	scale := anObject implicitCastTo: self class vector3Type
]

{ #category : #initialization }
GenericDecomposedTransform3d >> setIdentity [
	scale := self class vector3Type ones.
	rotation := self class quaternionType identity.
	translation := self class vector3Type zeros.
]

{ #category : #transformation }
GenericDecomposedTransform3d >> transformPosition: position [
	^ (self transformVector: position) + translation
]

{ #category : #transformation }
GenericDecomposedTransform3d >> transformVector: vector [
	^ rotation rotateVector: scale * vector
]

{ #category : #transforming }
GenericDecomposedTransform3d >> transformedWith: otherTransform [
	| otherDecomposedTransform |
	otherDecomposedTransform := otherTransform asDecomposedTransform3d.
	^ self class basicNew
		scale: otherDecomposedTransform scale * scale;
		rotation: otherDecomposedTransform rotation * rotation;
		translation: (otherDecomposedTransform transformVector: translation) + otherDecomposedTransform translation;
		yourself
]

{ #category : #accessing }
GenericDecomposedTransform3d >> translation [

	^ translation
]

{ #category : #accessing }
GenericDecomposedTransform3d >> translation: anObject [

	translation := anObject implicitCastTo: self class vector3Type
]
