Class {
	#name : #SYMLAPSGDictionaryConstruction,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'associations',
		'dictionaryType'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGDictionaryConstruction >> analyzeAndEvaluateInEnvironment: anEnvironment [
	| result association associationType associationContent associationKey associationValue |
	result := Dictionary new.
	associations do: [ :assoc |
		association := assoc analyzeAndEvaluateInEnvironment: anEnvironment.
		associationType := association type.
		(associationType isTupleType not or: [associationType types size ~= 2]) ifTrue: [ 
			self error: 'Expected 2-tuple for a dictionary value. 'at: assoc
		].

		associationContent := association unwrapSysmelValue.
		associationKey := associationContent first sysmelValueWithType: associationType types first inEnvironment: anEnvironment.
		associationValue := associationContent second sysmelValueWithType: associationType types second inEnvironment: anEnvironment.
		result at: associationKey put: associationValue
	].

	^ result sysmelValueWithType: anEnvironment compilationTarget literalAnyDictionaryType inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGDictionaryConstruction >> associations [
	^ associations
]

{ #category : #accessing }
SYMLAPSGDictionaryConstruction >> associations: anObject [
	associations := anObject
]

{ #category : #accessing }
SYMLAPSGDictionaryConstruction >> dictionaryType [
	^ dictionaryType
]

{ #category : #accessing }
SYMLAPSGDictionaryConstruction >> dictionaryType: anObject [
	dictionaryType := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGDictionaryConstruction >> evaluateInEnvironment: anEnvironment [
	| result association associationType associationContent associationKey associationValue |
	result := Dictionary new.
	associations do: [ :assoc |
		association := assoc analyzeAndEvaluateInEnvironment: anEnvironment.
		associationType := association type.
		self assert: (associationType isTupleType and: [ associationType types size = 2 ]).
	
		associationContent := association unwrapSysmelValue.
		associationKey := associationContent first sysmelValueWithType: associationType types first inEnvironment: anEnvironment.
		associationValue := associationContent second sysmelValueWithType: associationType types second inEnvironment: anEnvironment.
		result at: associationKey put: associationValue
	].

	^ result sysmelValueWithType: anEnvironment compilationTarget literalAnyDictionaryType inEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGDictionaryConstruction >> evaluateTypeInEnvironment: anEnvironment [
	^ dictionaryType
]

{ #category : #testing }
SYMLAPSGDictionaryConstruction >> isDictionaryConstructionNode [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGDictionaryConstruction >> semanticAnalysisInEnvironment: anEnvironment [
	| analyzedAssociatons associationType |
	dictionaryType ifNotNil: [ ^ self ].

	analyzedAssociatons := associations collect: [ :assoc | assoc semanticAnalysisInEnvironment: anEnvironment ].
	analyzedAssociatons do: [ :assoc |
		associationType := assoc evaluateTypeInEnvironment: anEnvironment.
		(associationType isTupleType not or: [ associationType types size ~= 2 ]) ifTrue: [ 
			self error: 'Expected 2-tuple for dictionary value.' at: assoc
		]
	].

	^ self shallowCopy
		dictionaryType: anEnvironment compilationTarget literalAnyDictionaryType;
		associations: analyzedAssociatons;
		yourself
]
