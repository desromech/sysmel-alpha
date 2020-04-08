Class {
	#name : #MbndToDerivedTypeConceptConversionRule,
	#superclass : #MbndToCompilerObjectTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #testing }
MbndToDerivedTypeConceptConversionRule >> canBeUsedToConvertNode: node from: sourceType into: targetType [
	| sourceConcept targetConcept |
	sourceType class == targetType class ifFalse: [ ^ false ].
	sourceType isDerivedType ifFalse: [ ^ false ].
	
	sourceConcept := sourceType baseType.
	targetConcept := targetType baseType.
	(sourceConcept isTypeConcept and: [ targetType doesCoercionTypeComplyWithConcept: targetConcept ]) ifTrue: [ ^ true ].
	(targetConcept isTrait and: [ sourceConcept isSubtypeOf: targetConcept ]) ifTrue: [ ^ true ].
	^ false
]
