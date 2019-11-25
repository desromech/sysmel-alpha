Class {
	#name : #MbndGCClassVariableDataArrayType,
	#superclass : #MbndAggregateType,
	#instVars : [
		'elementType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndGCClassVariableDataArrayType class >> typeName [
	^ #_GCClassVariableDataArrayType
]

{ #category : #visiting }
MbndGCClassVariableDataArrayType >> accept: visitor [
	^ visitor visitGCClassVariableDataArrayType: self
]

{ #category : #initialization }
MbndGCClassVariableDataArrayType >> addInstanceMacros [
	self class == MbndGCClassVariableDataArrayType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #size do: [ :node :builder |
			builder literalInteger: 0
			"(builder array: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself."
		];
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder gcVariableDataArray: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder gcVariableDataArray: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		]
]

{ #category : #'default values' }
MbndGCClassVariableDataArrayType >> defaultValueAt: aPosition [
	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: (elementType == self compilationTarget uint8Type ifTrue: [ #[] ] ifFalse: [#()]);
		yourself
]

{ #category : #accessing }
MbndGCClassVariableDataArrayType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndGCClassVariableDataArrayType >> elementType: anObject [
	elementType := anObject
]

{ #category : #sizes }
MbndGCClassVariableDataArrayType >> instanceAlignment [
	^ elementType instanceAlignment
]

{ #category : #sizes }
MbndGCClassVariableDataArrayType >> instanceSize [
	^ 0
]

{ #category : #testing }
MbndGCClassVariableDataArrayType >> isGCClassVariableDataArrayType [
	^ true
]

{ #category : #printing }
MbndGCClassVariableDataArrayType >> printOn: aStream [
	elementType printOn: aStream.
	aStream nextPutAll: ' gcVariableDataArray'
]
