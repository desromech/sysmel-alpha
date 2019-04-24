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

{ #category : #adding }
MbndLiteralValueType >> addLiteralHostDelegationMacrosFor: selectors [
	| macro |
	macro := MbndLiteralHostDelegation new.
	selectors do: [ :selector |
		self macroMethodDict at: selector put: macro
	].
]

{ #category : #'semantic analysis' }
MbndLiteralValueType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| bestConcreteType |
	self assert: node receiver isLiteralValueNode.
	bestConcreteType := self bestConcreteTypeForLiteralValueNode: node receiver inScope: analyzer scope.
	
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

{ #category : #casting }
MbndLiteralValueType >> createNode: node explicitCastTo: target with: analyzer [
	node isLiteralValueNode ifTrue: [
		(target isAcceptableLiteralValue: node value) ifTrue: [
			^ node copy
				value: (target legalizeLiteralValue: node value);
				type: target;
				yourself
		]
	].

	^ super createNode: node explicitCastTo: target with: analyzer
]

{ #category : #casting }
MbndLiteralValueType >> createNode: node implicitCastTo: target with: analyzer [
	node isLiteralValueNode ifTrue: [
		(target isAcceptableLiteralValue: node value) ifTrue: [
			^ node copy
				value: (target legalizeLiteralValue: node value);
				type: target;
				yourself
		]
	].

	^ super createNode: node implicitCastTo: target with: analyzer
]

{ #category : #'type inference' }
MbndLiteralValueType >> inferValueTypeForNode: initialValueNode inScope: scope [
	self assert: initialValueNode isLiteralValueNode.
	^ self bestConcreteTypeForLiteralValueNode: initialValueNode inScope: scope
]

{ #category : #testing }
MbndLiteralValueType >> isLiteralValueType [
	^ true
]
