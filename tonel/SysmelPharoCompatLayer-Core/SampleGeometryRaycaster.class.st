Class {
	#name : #SampleGeometryRaycaster,
	#superclass : #Object,
	#category : #'SysmelPharoCompatLayer-Core-Math-Geometry'
}

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster class >> exampleBox [
	^ self new
		rayCastShape: BoxF32 unitBox
		color: Color yellow darker asFloat32x3
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster class >> exampleBoxGJK [
	^ self new
		rayCastSupportFunction: BoxF32 unitBox supportFunction
		color: Color yellow darker asFloat32x3
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster class >> exampleEllipsoidGJK [
	^ self new
		rayCastSupportFunction: (EllipsoidF32 new
			radiuses: (Float32x3 x: 1.0 y: 0.5 z: 0.3);
			supportFunction)
		color: Color yellow darker asFloat32x3
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster class >> exampleSphere [
	^ self new
		rayCastShape: (SphereF32 new
			radius: 1.0;
			yourself)
		color: Color yellow darker asFloat32x3
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster class >> exampleSphereGJK [
	^ self new
		rayCastSupportFunction: (SphereF32 new
			radius: 1.0;
			supportFunction)
		color: Color yellow darker asFloat32x3
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster >> rayCastAndShadeWith: rayCastBlock [
	| w h aspect frustum bits destIndex |
	w := 256.
	h := 256.
	aspect := w/h.

	frustum := FrustumF32 new 
		makePerspectiveFovY: 60.0 aspect: aspect near: 0.1 far: 1000.0;
		transformedWith: (ReversibleAffineTransform3dF32 identity
			rotateDegreesOnX: -15;
			translateByY: 1.0;
			translateByZ: 3.0;
			yourself).

	bits := WordArray new: w*h.
	destIndex := 1.

	0 to: h - 1 do: [ :y |
		|v|
		v := 1.0 - (y / h)  asFloat.
		0 to: w - 1 do: [ :x |
			| u ray color colorBits r g b a |
			u := (x / w) asFloat.
			
			ray := frustum rayForNormalizedPoint: u@v.
			
			color := rayCastBlock value: ray.

			r := (color x*255) floor.
			g := (color y*255) floor.
			b := (color z*255) floor.
			a := (color w*255) floor.
			colorBits := b | (g << 8) | (r << 16) | (a << 24).
			bits at: destIndex put: colorBits.
			
			destIndex := destIndex + 1
		]
	].

	^ (Form extent: w@h depth: 32 bits: bits) asMorph inspect

]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster >> rayCastShape: shape color: color [
	^ self rayCastAndShadeWith: [:ray |
		(shape intersectionWithRay: ray) ifNil: [
			Float32x4 x: 0.2 y: 0.2 z: 0.5 w: 1.0
		] ifNotNil: [:t |
			| intersectionPoint normal NdotV |
			intersectionPoint := ray pointAtDistance: t.
			normal := shape computeNormalForPoint: intersectionPoint.
			NdotV := (ray direction negated dot: normal) max: 0.0.
			Float32x4 xyz: NdotV*color w: 1.0.
		].
	]
]

{ #category : #'as yet unclassified' }
SampleGeometryRaycaster >> rayCastSupportFunction: supportFunction color: color [
	^ self rayCastAndShadeWith: [:ray |
		(GJK ray: ray castFor: supportFunction) ifNil: [
			Float32x4 x: 0.2 y: 0.2 z: 0.5 w: 1.0
		] ifNotNil: [:distanceAndNormal |
			| normal NdotV |
			normal := distanceAndNormal second normalized.
			NdotV := (ray direction negated dot: normal) max: 0.0.
			Float32x4 xyz: NdotV*color w: 1.0.
		].
	]
]
