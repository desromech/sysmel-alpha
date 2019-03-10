Class {
	#name : #MbndSmalltalkImageModule,
	#superclass : #Object,
	#traits : 'TMbndModule',
	#classTraits : 'TMbndModule classTrait',
	#instVars : [
		'typesForBehaviors'
	],
	#classInstVars : [
		'uniqueInstance',
		'systemUniqueInstance'
	],
	#category : #'MoebiusBandMetamodel-Core-In-Image'
}

{ #category : #singleton }
MbndSmalltalkImageModule class >> new [
	self error: 'You cannot create an instance from me. Use uniqueInstance.'
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> reset [ 
	uniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> setUpCleanForTest [
	systemUniqueInstance := uniqueInstance.
	uniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> tearDownCleanForTest [
	uniqueInstance := systemUniqueInstance.
	systemUniqueInstance := nil
]

{ #category : #singleton }
MbndSmalltalkImageModule class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #initialization }
MbndSmalltalkImageModule >> initialize [
	super initialize.
	typesForBehaviors := WeakKeyDictionary new.
]

{ #category : #'as yet unclassified' }
MbndSmalltalkImageModule >> typeForBehavior: aBehavior [
	^ typesForBehaviors at: aBehavior ifAbsentPut: [ MbndImageBehaviorType new
			definitionModule: self;
			behavior: aBehavior;
			yourself
	]
]
