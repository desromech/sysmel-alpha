Class {
	#name : #SYMLIntrinsicFunction,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#classVars : [
		'IntrinsicFunctionDictionary'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #adding }
SYMLIntrinsicFunction class >> addIntrinsic: intrinsicName block: aBlock [
	IntrinsicFunctionDictionary at: intrinsicName put:
		(SYMLIntrinsicBlockFunction new
			name: intrinsicName;
			block: aBlock;
			yourself)
]

{ #category : #'instance creation' }
SYMLIntrinsicFunction class >> fromName: intrinsicName [
	^ IntrinsicFunctionDictionary at: intrinsicName ifAbsent: [ nil ]
]

{ #category : #initialization }
SYMLIntrinsicFunction class >> initialize [
	IntrinsicFunctionDictionary := Dictionary new.
	
	self withAllSubclassesDo: [ :cls |
		cls class methodDict valuesDo: [ :method |
			(method hasPragmaNamed: #intrinsics) ifTrue: [ 
				cls perform: method selector
			]
		]
	]
]

{ #category : #intrinsics }
SYMLIntrinsicFunction class >> vectorInstructions [
	<intrinsics>
	self
		addIntrinsic: #'vector.add' block: [ :arguments :builder |
			builder vectorAdd: arguments first with: arguments second
		];
		addIntrinsic: #'vector.sub' block: [ :arguments :builder |
			builder vectorSub: arguments first with: arguments second
		];
		addIntrinsic: #'vector.mul' block: [ :arguments :builder |
			builder vectorMul: arguments first with: arguments second
		];
		addIntrinsic: #'vector.div' block: [ :arguments :builder |
			builder vectorDiv: arguments first with: arguments second
		];
		addIntrinsic: #'vector.rem' block: [ :arguments :builder |
			builder vectorRem: arguments first with: arguments second
		];

		yourself
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicFunction >> generateSSACallWithArguments: argumentValues builder: builder at: position [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicFunction >> generateSSACallWithReceiver: receiverValue arguments: argumentValues withBuilder: builder at: position [
	receiverValue ifNil: [
		^ self generateSSACallWithArguments: argumentValues builder: builder at: position
	] ifNotNil: [ 
		^ self generateSSACallWithArguments: {receiverValue} , argumentValues builder: builder at: position
	]
]

{ #category : #accessing }
SYMLIntrinsicFunction >> name [
	^ name
]

{ #category : #accessing }
SYMLIntrinsicFunction >> name: anObject [
	name := anObject
]
