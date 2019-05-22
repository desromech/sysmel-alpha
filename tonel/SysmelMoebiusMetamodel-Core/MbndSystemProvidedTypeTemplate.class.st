Class {
	#name : #MbndSystemProvidedTypeTemplate,
	#superclass : #MbndAbstractTemplate,
	#instVars : [
		'compilationTarget',
		'instances',
		'mainDefinitionConstructionBlock'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #visiting }
MbndSystemProvidedTypeTemplate >> accept: aVisitor [
	^ aVisitor visitSystemProvidedTypeTemplate: self
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #template }
MbndSystemProvidedTypeTemplate >> getOrCreateInstanceWithArguments: arguments [
	^ instances at: arguments ifAbsentPut: [
		mainDefinitionConstructionBlock valueWithArguments: arguments.
	]
]

{ #category : #initialization }
MbndSystemProvidedTypeTemplate >> initialize [
	super initialize.
	instances := WeakValueDictionary new.
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> mainDefinitionConstructionBlock [
	^ mainDefinitionConstructionBlock
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> mainDefinitionConstructionBlock: anObject [
	mainDefinitionConstructionBlock := anObject
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplate >> type [
	^ self compilationTarget typeTemplateType
]
