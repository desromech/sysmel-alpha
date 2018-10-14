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

{ #category : #intrinsics }
SYMLIntrinsicFunction class >> atomicInstructions [
	<intrinsics>
	self
		addIntrinsic: #'atomic.compare_and_swap' builtInNamed: 'atomic.compare_and_swap';
		addIntrinsic: #'atomic.fetch_and_add' builtInNamed: 'atomic.fetch_and_add';
		addIntrinsic: #'atomic.fetch_and_subtract' builtInNamed: 'atomic.fetch_and_subtract';
		addIntrinsic: #'atomic.swap_value' builtInNamed: 'atomic.compare_and_swap';
		yourself
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
SYMLIntrinsicFunction class >> objectInstructions [
	<intrinsics>
	self
		addIntrinsic: #'dynobject.identityEquals' block: [ :arguments :returnType :builder |
			builder dynObjectIdentityEquals: arguments first with: arguments second
		];
		addIntrinsic: #'dynobject.identityNotEquals' block: [ :arguments :returnType :builder |
			builder dynObjectIdentityNotEquals: arguments first with: arguments second
		];
		yourself
]

{ #category : #intrinsics }
SYMLIntrinsicFunction class >> pointerInstructions [
	<intrinsics>
	self
		addIntrinsic: #'pointer.equals' block: [ :arguments :returnType :builder |
			builder ieq: arguments first with: arguments second
		];
		addIntrinsic: #'pointer.notEquals' block: [ :arguments :returnType :builder |
			builder ine: arguments first with: arguments second
		];
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
		addIntrinsic: #'vector.dot' builtInNamed: 'vector.dot';
		addIntrinsic: #'vector.cross' builtInNamed: 'vector.cross';
		addIntrinsic: #'vector.length' builtInNamed: 'vector.length';
		addIntrinsic: #'vector.normalize' builtInNamed: 'vector.normalize';
		addIntrinsic: #'vector.reflect' builtInNamed: 'vector.reflect';
		addIntrinsic: #'vector.refract' builtInNamed: 'vector.refract';

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
