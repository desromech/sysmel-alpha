Class {
	#name : #GenericFrustum,
	#superclass : #GenericGeometricShape,
	#instVars : [
		'leftBottomNear',
		'rightBottomNear',
		'leftTopNear',
		'rightTopNear',
		'leftBottomFar',
		'rightBottomFar',
		'leftTopFar',
		'rightTopFar',
		'planes'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #testing }
GenericFrustum class >> isAbstract [
	^ self == GenericFrustum
]

{ #category : #'as yet unclassified' }
GenericFrustum class >> typeOfGenericSlotNamed: slotName [
	(#(leftBottomNear rightBottomNear leftTopNear rightTopNear leftBottomFar rightBottomFar leftTopFar rightTopFar) includes: slotName) ifTrue: [ ^ self vector3Type ].
	slotName = #planes ifTrue: [ ^ self planeType array: 6  ].
	^ super typeOfGenericSlotNamed: slotName
]

{ #category : #comparing }
GenericFrustum >> = other [
	^ self class == other class and: [
	leftBottomNear = other leftBottomNear and: [
	rightBottomNear = other rightBottomNear and: [
	leftTopNear = other leftTopNear and: [
	rightTopNear = other rightTopNear and: [
		
	leftBottomFar = other leftBottomFar and: [
	rightBottomFar = other rightBottomFar and: [
	leftTopFar = other leftTopFar and: [
	rightTopFar = other rightTopFar ]]]]]]]]
]

{ #category : #accessing }
GenericFrustum >> bottomPlane [
	^ planes fifth
]

{ #category : #accessing }
GenericFrustum >> boundingBox [
	^ self class boxType encompassingPoints: self corners
]

{ #category : #private }
GenericFrustum >> computePlanes [
	planes := (self class planeType array: 6) with: { 
		"Near plane"
   		(self class planeType point: leftBottomNear point: rightBottomNear point: leftTopNear).
		"Far plane"
   		(self class planeType point: rightBottomFar point: leftBottomFar point: leftTopFar).

		"Left"
		(self class planeType point: leftBottomNear point: leftTopNear point: leftTopFar).
		"Right"
		(self class planeType point: rightTopNear point: rightBottomNear point: rightTopFar).

		"Bottom"
   		(self class planeType point: rightBottomNear point: leftBottomNear point: leftBottomFar).
		"Top"
		(self class planeType point: leftTopNear point: rightTopNear point: leftTopFar)
	}
]

{ #category : #accessing }
GenericFrustum >> corners [
	^ {
		leftBottomNear.
		rightBottomNear. 
		leftTopNear. 
		rightTopNear. 

		leftBottomFar.
		rightBottomFar. 
		leftTopFar. 
		rightTopFar. 
	}
]

{ #category : #accessing }
GenericFrustum >> cornersDo: aBlock [
	aBlock value: leftBottomNear.
	aBlock value: rightBottomNear. 
	aBlock value: leftTopNear. 
	aBlock value: rightTopNear. 

	aBlock value: leftBottomFar.
	aBlock value: rightBottomFar.
	aBlock value: leftTopFar.
	aBlock value: rightTopFar.

]

{ #category : #accessing }
GenericFrustum >> farPlane [
	^ planes second
]

{ #category : #comparing }
GenericFrustum >> hash [
	| result |
	result := leftBottomNear hash.
	result := result hashMultiply + rightBottomNear hash.
	result := result hashMultiply + leftTopNear hash.
	result := result hashMultiply + rightTopNear hash.
	
	result := result hashMultiply + leftBottomFar hash.
	result := result hashMultiply + rightBottomFar hash.
	result := result hashMultiply + leftTopFar hash.
	result := result hashMultiply + rightTopFar hash.
	^ result
]

{ #category : #accessing }
GenericFrustum >> intersectsOrContainsBox: box [
	^ (self isBoxOutside: box) not
]

{ #category : #accessing }
GenericFrustum >> isBoxOutside: box [
	"This technique comes from this article: http://www.lighthouse3d.com/tutorials/view-frustum-culling/geometric-approach-testing-boxes-ii/"
	^ planes anySatisfy: [ :each |
		each isInFront: (box negativeVertex: each normal)
	]
]

{ #category : #accessing }
GenericFrustum >> leftBottomFar [
	^ leftBottomFar
]

{ #category : #accessing }
GenericFrustum >> leftBottomFar: anObject [
	leftBottomFar := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> leftBottomNear [
	^ leftBottomNear
]

{ #category : #accessing }
GenericFrustum >> leftBottomNear: anObject [
	leftBottomNear := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> leftPlane [
	^ planes third
]

{ #category : #accessing }
GenericFrustum >> leftTopFar [
	^ leftTopFar
]

{ #category : #accessing }
GenericFrustum >> leftTopFar: anObject [
	leftTopFar := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> leftTopNear [
	^ leftTopNear
]

{ #category : #accessing }
GenericFrustum >> leftTopNear: anObject [
	leftTopNear := anObject implicitCastTo: self class vector3Type
]

{ #category : #computation }
GenericFrustum >> makeFrustumLeft: left right: right bottom: bottom top: top near: near far: far [
	| vector3 factor |
	vector3 := self class vector3Type.
	leftBottomNear := vector3 x: left y: bottom z: near negated.
	rightBottomNear := vector3 x: right y: bottom z: near negated.
	leftTopNear := vector3 x: left y: top z: near negated.
	rightTopNear := vector3 x: right y: top z: near negated.

	factor := far / near.
	leftBottomFar := leftBottomNear * factor.
	rightBottomFar := rightBottomNear * factor.
	leftTopFar := leftTopNear * factor.
	rightTopFar := rightTopNear * factor.

	self computePlanes.
]

{ #category : #computation }
GenericFrustum >> makeOrthoLeft: left right: right bottom: bottom top: top near: near far: far [
	| vector3 |
	vector3 := self class vector3Type.
	leftBottomNear := vector3 x: left y: bottom z: near negated.
	rightBottomNear := vector3 x: right y: bottom z: near negated.
	leftTopNear := vector3 x: left y: top z: near negated.
	rightTopNear := vector3 x: right y: top z: near negated.

	leftBottomFar := vector3 x: left y: bottom z: far negated.
	rightBottomFar := vector3 x: right y: bottom z: far negated.
	leftTopFar := vector3 x: left y: top z: far negated.
	rightTopFar := vector3 x: right y: top z: far negated.

	self computePlanes.

]

{ #category : #computation }
GenericFrustum >> makePerspectiveFovY: fovy aspect: aspect near: near far: far [
	| fovyRad top right |
	fovyRad := fovy degreesToRadians * 0.5f.
	top := near * fovyRad tan.
	right := top * aspect.
	self makeFrustumLeft: right negated right: right bottom: top negated top: top near: near far: far
]

{ #category : #accessing }
GenericFrustum >> nearPlane [
	^ planes first
]

{ #category : #computation }
GenericFrustum >> normalizedPointInFarPlane: normalizedPoint [
	^ (leftBottomFar interpolateTo: rightBottomFar at: normalizedPoint x) interpolateTo:
		(leftTopFar interpolateTo: rightTopFar at: normalizedPoint x) at: normalizedPoint y.
]

{ #category : #computation }
GenericFrustum >> normalizedPointInNearPlane: normalizedPoint [
	^ (leftBottomNear interpolateTo: rightBottomNear at: normalizedPoint x) interpolateTo:
		(leftTopNear interpolateTo: rightTopNear at: normalizedPoint x) at: normalizedPoint y.
]

{ #category : #accessing }
GenericFrustum >> planes [
	^ planes
]

{ #category : #computation }
GenericFrustum >> rayForNormalizedPoint: normalizedPoint [
	| nearPoint farPoint |
	nearPoint := self normalizedPointInNearPlane: normalizedPoint.
	farPoint := self normalizedPointInFarPlane: normalizedPoint.
	^ self class ray3dType from: nearPoint to: farPoint
]

{ #category : #accessing }
GenericFrustum >> rightBottomFar [
	^ rightBottomFar
]

{ #category : #accessing }
GenericFrustum >> rightBottomFar: anObject [
	rightBottomFar := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> rightBottomNear [
	^ rightBottomNear
]

{ #category : #accessing }
GenericFrustum >> rightBottomNear: anObject [
	rightBottomNear := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> rightPlane [
	^ planes fourth
]

{ #category : #accessing }
GenericFrustum >> rightTopFar [
	^ rightTopFar
]

{ #category : #accessing }
GenericFrustum >> rightTopFar: anObject [
	rightTopFar := anObject implicitCastTo: self class vector3Type
]

{ #category : #accessing }
GenericFrustum >> rightTopNear [
	^ rightTopNear
]

{ #category : #accessing }
GenericFrustum >> rightTopNear: anObject [
	rightTopNear := anObject implicitCastTo: self class vector3Type
]

{ #category : #transforming }
GenericFrustum >> splitAtNearLambda: splitNearLambda farLambda: splitFarLambda [
	^ self class basicNew
		leftBottomNear: (leftBottomNear interpolateTo: leftBottomFar at: splitNearLambda);
		rightBottomNear: (rightBottomNear interpolateTo: rightBottomFar at: splitNearLambda);
		leftTopNear: (leftTopNear interpolateTo: leftTopFar at: splitNearLambda);
		rightTopNear: (rightTopNear interpolateTo: rightTopFar at: splitNearLambda);

		leftBottomFar: (leftBottomNear interpolateTo: leftBottomFar at: splitFarLambda);
		rightBottomFar: (rightBottomNear interpolateTo: rightBottomFar at: splitFarLambda);
		leftTopFar: (leftTopNear interpolateTo: leftTopFar at: splitFarLambda);
		rightTopFar: (rightTopNear interpolateTo: rightTopFar at: splitFarLambda);
		computePlanes;
		yourself
]

{ #category : #accessing }
GenericFrustum >> topPlane [
	^ planes sixth
]

{ #category : #transforming }
GenericFrustum >> transformedWith: transform [
	^ self class basicNew
		leftBottomNear: (transform transformPosition: leftBottomNear);
		rightBottomNear: (transform transformPosition: rightBottomNear);
		leftTopNear: (transform transformPosition: leftTopNear);
		rightTopNear: (transform transformPosition: rightTopNear);

		leftBottomFar: (transform transformPosition: leftBottomFar);
		rightBottomFar: (transform transformPosition: rightBottomFar);
		leftTopFar: (transform transformPosition: leftTopFar);
		rightTopFar: (transform transformPosition: rightTopFar);
		computePlanes;
		yourself
]
