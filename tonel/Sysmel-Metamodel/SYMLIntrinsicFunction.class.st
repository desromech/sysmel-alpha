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

{ #category : #adding }
SYMLIntrinsicFunction class >> addIntrinsic: intrinsicName builtInNamed: builtInName [
	IntrinsicFunctionDictionary at: intrinsicName put:
		(SYMLIntrinsicBuiltInFunction new
			name: intrinsicName;
			builtInName: builtInName;
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
SYMLIntrinsicFunction class >> matrixInstructions [
	<intrinsics>
	self
		addIntrinsic: #'matrix.add' block: [ :arguments :returnType :builder |
			builder matrixAdd: arguments first with: arguments second
		];
		addIntrinsic: #'matrix.sub' block: [ :arguments :returnType :builder |
			builder matrixSub: arguments first with: arguments second
		];
		addIntrinsic: #'matrix.vectorTimesMatrix' block: [ :arguments :returnType :builder |
			builder mulVector: arguments first withMatrix: arguments second
		];
		addIntrinsic: #'matrix.matrixTimesVector' block: [ :arguments :returnType :builder |
			builder mulMatrix: arguments first withVector: arguments second
		];
		addIntrinsic: #'matrix.matrixTimesMatrix' block: [ :arguments :returnType :builder |
			builder mulMatrix: arguments first withMatrix: arguments second
		];
		yourself
]

{ #category : #intrinsics }
SYMLIntrinsicFunction class >> matrixOperations [
	<intrinsics>
	self
		addIntrinsic: #'matrix.transpose' builtInNamed: 'matrix.transpose';
		yourself
]

{ #category : #intrinsics }
SYMLIntrinsicFunction class >> vectorInstructions [
	<intrinsics>
	self
		addIntrinsic: #'vector.add' block: [ :arguments :returnType :builder |
			builder vectorAdd: arguments first with: arguments second
		];
		addIntrinsic: #'vector.sub' block: [ :arguments :returnType :builder |
			builder vectorSub: arguments first with: arguments second
		];
		addIntrinsic: #'vector.mul' block: [ :arguments :returnType :builder |
			builder vectorMul: arguments first with: arguments second
		];
		addIntrinsic: #'vector.div' block: [ :arguments :returnType :builder |
			builder vectorDiv: arguments first with: arguments second
		];
		addIntrinsic: #'vector.rem' block: [ :arguments :returnType :builder |
			builder vectorRem: arguments first with: arguments second
		];

		yourself
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicFunction >> generateSSACallWithArguments: argumentValues returnType: returnType  builder: builder at: position [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicFunction >> generateSSACallWithReceiver: receiverValue arguments: argumentValues returnType: returnType withBuilder: builder at: position [
	receiverValue ifNil: [
		^ self generateSSACallWithArguments: argumentValues returnType: returnType  builder: builder at: position
	] ifNotNil: [ 
		^ self generateSSACallWithArguments: {receiverValue} , argumentValues returnType: returnType builder: builder at: position
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
