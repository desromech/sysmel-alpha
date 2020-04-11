Class {
	#name : #MbndSystemProvidedTypeTemplateInstance,
	#superclass : #MbndAbstractTemplateInstance,
	#instVars : [
		'instanceArguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndSystemProvidedTypeTemplateInstance class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	(#(SystemProvidedTypeTemplateInstance
	 SystemProvidedTypeTemplateInstanceMainChild
	 SystemProvidedTypeTemplateInstanceMainChildType) includes: objectType) ifTrue: [	
		| fields systemTypeTemplate proxy instance |
		proxy := graphDecoder registerObjectInstanceProxy.
		fields := Dictionary newFromPairs: graphDecoder decodeNext.
		systemTypeTemplate := graphDecoder compilationTarget getBasicTypeNamed: (fields at: #systemTypeTemplate).
	
		instance := systemTypeTemplate getOrCreateInstanceWithArguments: (fields at: #instanceArguments).
		objectType == #SystemProvidedTypeTemplateInstanceMainChildType ifTrue: [
			instance := instance type
		].
		objectType == #SystemProvidedTypeTemplateInstance ifTrue: [
			instance := instance parent
		].
		
		graphDecoder objectInstanceProxy: proxy concretizeWith: instance.
		^ instance
	].

	^ super materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder
]

{ #category : #'as yet unclassified' }
MbndSystemProvidedTypeTemplateInstance >> attemptToSetMainAliasTo: aCompileTimeConstant [
	"This method is ignored here."
]

{ #category : #initialization }
MbndSystemProvidedTypeTemplateInstance >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplateInstance >> instanceArguments [
	^ instanceArguments
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplateInstance >> instanceArguments: anObject [
	instanceArguments := anObject
]

{ #category : #testing }
MbndSystemProvidedTypeTemplateInstance >> isSystemProvidedTypeTemplateInstance [
	^ true
]

{ #category : #accessing }
MbndSystemProvidedTypeTemplateInstance >> module [
	^ parent module
]
