"
I represent the type for a literal value. I only exists in compile time to facilitate type inference, and enforce compile time constant values. After compilation, my values are lowered into actual concrete types.
"
Class {
	#name : #MbndLiteralValueType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralValueType class >> typeName [
	^ #_LiteralValueType
]

{ #category : #visiting }
MbndLiteralValueType >> accept: aVisitor [
	^ aVisitor visitLiteralValueType: self
]

{ #category : #casting }
MbndLiteralValueType >> addConversionRulesToTargetType: targetType [
	self
		addConversionTo: targetType rule: MbndLiteralToTargetTypeConversionRule new;
		addConversionTo: targetType rule: MbndLiteralToBestTargetTypeConversionRule new.

]

{ #category : #adding }
MbndLiteralValueType >> addLiteralHostDelegationMacroFor: selector to: hostSelector [
	self macroMethodDict at: selector put: (MbndLiteralHostDelegation new
		hostSelector: hostSelector;
		yourself
	)
]

{ #category : #adding }
MbndLiteralValueType >> addLiteralHostDelegationMacrosFor: selectors [
	selectors do: [ :sel | self addLiteralHostDelegationMacroFor: sel to: sel ]
]

{ #category : #'semantic analysis' }
MbndLiteralValueType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| bestConcreteType newNode |
	self assert: node expression isLiteralValueNode.
	bestConcreteType := self standardConcreteTypeForLiteralValueNode: node expression inScope: analyzer scope.
	newNode := node copy.
	newNode expression: (newNode expression copy type: bestConcreteType).
	^ bestConcreteType analyzeReinterpretCastNode: newNode to: targetType with: analyzer
]

{ #category : #'semantic analysis' }
MbndLiteralValueType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| bestConcreteType |
	self assert: node receiver isLiteralValueNode.
	bestConcreteType := self standardConcreteTypeForLiteralValueNode: node receiver inScope: analyzer scope.
	
	"Apply the concrete literal type, and analyze again. Allow a second oppotunity for doing macro expansion."
	^ analyzer visitNode: (node asUnexpandedMessageSend
		receiver: (node receiver copy type: bestConcreteType);
		yourself)
]

{ #category : #'semantic analysis' }
MbndLiteralValueType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	"This should find the best concrete type for a specific literal value node"
	self subclassResponsibility
]

{ #category : #'type inference' }
MbndLiteralValueType >> inferValueTypeForNode: initialValueNode inScope: scope [
	self assert: initialValueNode isLiteralValueNode.
	^ self standardConcreteTypeForLiteralValueNode: initialValueNode inScope: scope
]

{ #category : #testing }
MbndLiteralValueType >> isLiteralValueType [
	^ true
]

{ #category : #testing }
MbndLiteralValueType >> isTrait [
	^ self class subclasses isEmpty
]

{ #category : #'semantic analysis' }
MbndLiteralValueType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	"This should find the best concrete type for a specific literal value node"
	self subclassResponsibility
]
