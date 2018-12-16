Class {
	#name : #SYMLClass,
	#superclass : #SYMLAbstractClass,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #conversions }
SYMLClass >> addConversionRulesToPointerTypeToMyself: pointerType [
	<compileTime>
	pointerType
		"Explicit static cast."
		addExplicitConversionRule: (SYMLStaticClassPointerCast when: [:source :target |
			source isPointerType and: [
			target isPointerType and: [ 
			source pointed isSysmelNativeClass and: [
			target pointed isSysmelNativeClass ]]]]);

		"Implicit static cast."
		addConversionRule: (SYMLStaticClassPointerCast when: [:source :target |
			source isPointerType and: [
			target isPointerType and: [
			source pointed isSysmelNativeClass and: [
			target pointed isSysmelNativeClass and: [
			source pointed isSubclassOf: target pointed ]]]]]);

		addConversionRule: (SYMLReinterpretPointerTypeConversionRule when: [:source :target |
			source pointed isSysmelKindOf: target pointed]).
	^ super addConversionRulesToPointerTypeToMyself: pointerType
]

{ #category : #conversions }
SYMLClass >> addConversionRulesToReferenceTypeToMyself: referenceType [
	<compileTime>
	referenceType
		"Implicit static cast."
		addConversionRule: (SYMLStaticClassPointerCast when: [:source :target |
			source isReferenceType and: [
			target isReferenceType and: [
			source referenced isSysmelNativeClass and: [
			target referenced isSysmelNativeClass and: [
			source referenced isSubclassOf: target referenced ]]]]]);

		addConversionRule: (SYMLReinterpretPointerTypeConversionRule when: [:source :target |
			source referenced isSysmelKindOf: target referenced]).
	^ super addConversionRulesToReferenceTypeToMyself: referenceType.
]

{ #category : #conversions }
SYMLClass >> isSysmelNativeClass [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLClass >> typeKindBaseTrait [
	^ self compilationTarget classTypeTrait
]
