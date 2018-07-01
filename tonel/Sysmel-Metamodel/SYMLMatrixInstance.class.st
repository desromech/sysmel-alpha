Class {
	#name : #SYMLMatrixInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLMatrixInstance class >> columnMajorIndicesForType: type [
	| elementType columns |
	elementType := type cachedNullary: #elementType.
	columns := type cachedNullary: #columns.
	
	^ self forType: type createWithBlock: [ :i :j |
		elementType numericalConstant: (j-1)*columns + (i-1)
	]
]

{ #category : #'as yet unclassified' }
SYMLMatrixInstance class >> forType: type createWithBlock: aBlock [
	| columnCount rowCount columnType |
	columnCount := type cachedNullary: #columns.
	rowCount := type cachedNullary: #rows.
	columnType := type cachedNullary: #columnType.

	^ (self new
		type: type;
		slots: ((1 to: columnCount) collect: [:j |
			SYMLVectorInstance new
				type: columnType;
				slots: ((1 to: rowCount) collect: [:i |
					aBlock value: i value: j
				]);
				yourself.
		]);
		yourself) asSysmelValueInEnvironment: environment
]

{ #category : #'as yet unclassified' }
SYMLMatrixInstance class >> forType: type withAll: value [
	| columnCount rowCount columnType column |
	columnCount := type cachedNullary: #columns.
	rowCount := type cachedNullary: #rows.
	columnType := type cachedNullary: #columnType.

	column := SYMLVectorInstance new
		type: columnType;
		slots: ((1 to: rowCount) collect: [:i | value ]);
		yourself.
	^ (self new
		type: type;
		slots: ((1 to: columnCount) collect: [:i | column]);
		yourself) asSysmelValueInEnvironment: environment
]

{ #category : #'as yet unclassified' }
SYMLMatrixInstance class >> identityForType: type [
	| one zero elementType |
	elementType := type cachedNullary: #elementType.
	one := elementType cachedNullary: #one.
	zero := elementType cachedNullary: #zero.
	^ self forType: type createWithBlock: [ :i :j |
		i = j ifTrue: [ one ] ifFalse: [ zero ]
	]
]

{ #category : #'as yet unclassified' }
SYMLMatrixInstance class >> rowMajorIndicesForType: type [
	| elementType rows |
	elementType := type cachedNullary: #elementType.
	rows := type cachedNullary: #rows.
	
	^ self forType: type createWithBlock: [ :i :j |
		elementType numericalConstant: (i-1)*rows + (j-1)
	]
]

{ #category : #converting }
SYMLMatrixInstance >> generateSSAReferenceWith: builder [
	^ builder makeMatrix: type ssaType arguments: (slots collect: [:slot | slot generateSSAReferenceWith: builder])
]

{ #category : #accessing }
SYMLMatrixInstance >> slots [
	^ slots
]

{ #category : #accessing }
SYMLMatrixInstance >> slots: anObject [
	slots := anObject
]
