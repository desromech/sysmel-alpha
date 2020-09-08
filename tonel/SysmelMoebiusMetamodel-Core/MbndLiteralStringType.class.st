Class {
	#name : #MbndLiteralStringType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralStringType class >> typeName [
	^ #_LiteralString
]

{ #category : #adding }
MbndLiteralStringType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self
		addConversionTo: self compilationTarget char8Type const pointer rule: MbndLiteralStringToCStringConversionRule;
		addConversionTo: self compilationTarget char16Type const pointer rule: MbndLiteralStringToCStringConversionRule;
		addConversionTo: self compilationTarget char32Type const pointer rule: MbndLiteralStringToCStringConversionRule;
		addConversionTo: self compilationTarget uint8Type const pointer rule: MbndLiteralStringToCStringBytePointerConversionRule.
]

{ #category : #converting }
MbndLiteralStringType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel stringClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'testing methods' }
MbndLiteralStringType >> isLiteralStringType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralStringType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget standardConcreteTypeForLiteralStringInScope: scope
]
