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

{ #category : #sizes }
TMbndMetaType >> instanceAlignment [
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
TMbndMetaType >> instanceSize [
	^ self compilationTarget pointerSize
]

{ #category : #accessing }
TMbndMetaType >> instanceType [
	<compileTime>
	^ instanceType
]

{ #category : #'testing methods' }
TMbndMetaType >> isMetaType [
	^ true
]

{ #category : #testing }
TMbndMetaType >> isStrictMetaType [
	^ instanceType isNotNil
]

{ #category : #printing }
TMbndMetaType >> qualifiedNameForParent [
	self isStrictMetaType ifTrue: [ 
		^ instanceType qualifiedNameForParent , ' type'
	].

	^ super qualifiedNameForParent
]
