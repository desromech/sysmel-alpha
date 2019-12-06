Class {
	#name : #MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'functionCodeGenerator',
		'assignmentValue'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator >> assignmentValue [
	^ assignmentValue
]

{ #category : #accessing }
MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator >> assignmentValue: anObject [
	assignmentValue := anObject
]

{ #category : #accessing }
MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator >> functionCodeGenerator [
	^ functionCodeGenerator
]

{ #category : #accessing }
MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator >> functionCodeGenerator: anObject [
	functionCodeGenerator := anObject.
	self codeModuleGenerator: functionCodeGenerator codeModuleGenerator
]

{ #category : #accessing }
MbndSlovimFunctionDestructuringPatternAssignmentCodeGenerator >> visitPatternMatchingBindingPatternNode: node [
	functionCodeGenerator generateLocalVariable: node binding definitionAt: node withInitialValue: assignmentValue.
	node value ifNotNil: [ ^ self visitNode: node value ].
]
