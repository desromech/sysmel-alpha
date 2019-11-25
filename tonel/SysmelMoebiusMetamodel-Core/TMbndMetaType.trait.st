Trait {
	#name : #TMbndMetaType,
	#instVars : [
		'instanceType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #initialization }
TMbndMetaType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self addConversionTo: self compilationTarget astNodeType rule: MbndWrapInLiteralValueNodeTypeConversionRule
]

{ #category : #accessing }
TMbndMetaType >> instanceType [
	^ instanceType
]

{ #category : #'testing methods' }
TMbndMetaType >> isMetaType [
	^ true
]
