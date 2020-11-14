Class {
	#name : #MbndIcebergProjectAssets,
	#superclass : #Object,
	#classInstVars : [
		'session',
		'location'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Directories'
}

{ #category : #'as yet unclassified' }
MbndIcebergProjectAssets class >> findAssets [
	| packageName |
	packageName := self package name.
	IceRepository registry
		detect: [ :each | each includesPackageNamed: packageName ]
		ifFound: [ :found | ^ found location ].

	^ Smalltalk imageDirectory
]

{ #category : #accessing }
MbndIcebergProjectAssets class >> location [
	session ~~ Smalltalk session ifTrue: [ 
		location := self findAssets.
		session := Smalltalk session
	].
	^ location
]
