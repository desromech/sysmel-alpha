Class {
	#name : #MbndSysmelLanguageSemanticEvaluationTest,
	#superclass : #MbndSysmelLanguageTestCommon,
	#category : #'SysmelLanguage-Sysmel-Tests-Parser'
}

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassDefaultArgumentAndReturnType [
	| protoObjectClass method dynobjectType |
	self evaluateMiniObjectModelRuntime.
	protoObjectClass := (self evaluateSource: '
		ProtoObject definition: {
			method operateWith: anArgument := self.
		}.
		
		ProtoObject
	') unwrapMbndValue.
	semanticModule finishSemanticAnalysis.

	method := protoObjectClass overloadedMethodDict at: #operateWith:.
	dynobjectType := semanticModule compilationTarget dynamicObjectType.
	self assert: dynobjectType equals: protoObjectClass.
	self assert: method returnType equals: dynobjectType.
	self assert: method argumentTypes first equals: dynobjectType.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassDefaultSuperClass [
	| sampleClass |
	self evaluateMiniObjectModelRuntime.
	sampleClass := (self evaluateSource: '
		gcclass SampleClass definition: {
		}.
		
		SampleClass
	') unwrapMbndValue.
	semanticModule finishSemanticAnalysis.

	self assert: sampleClass supertype name equals: #Object.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassIdentityHash [
	| protoObjectClass instance |
	protoObjectClass := self evaluateSource: '
		gcclass ProtoObject definition: {
			field __identityHash private type: UInt32; bits: 22.
			field __variableDataSize private type: UInt32.
		}
	'.
	
	instance := protoObjectClass unwrapMbndValue makeInstance: 0 identityHash: 42.
	self assert: instance __identityHashValue value equals: 42.
	self assert: instance __variableDataSizeValue value equals: 0.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassMetaType [
	| protoObjectType classType metaClassType |
	self evaluateMiniObjectModelRuntime.
	protoObjectType := (self evaluateSource: 'ProtoObject') unwrapMbndValue.
	classType := (self evaluateSource: 'Class') unwrapMbndValue.
	metaClassType := (self evaluateSource: 'Metaclass') unwrapMbndValue.
	
	self assert: protoObjectType isGCClassType.
	self deny: protoObjectType isMetaType.
	self assert: protoObjectType type isGCClassType.
	self assert: protoObjectType type isMetaType.
	self assert: protoObjectType type type equals: metaClassType.
	self assert: metaClassType isGCClassType.
	self assert: metaClassType isMetaTypeType.
	self deny: metaClassType isMetaType.
	self assert: protoObjectType type supertype equals: classType.

]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassMethodDictionary [
	| protoObjectClass methodDictionaryContent methodDictionaryObject |
	self evaluateMiniObjectModelRuntime.
	protoObjectClass := (self evaluateSource: '
		ProtoObject definition: {
			method returnSelf => ProtoObject := self.
			method returnSelf2 => ProtoObject := self.
			method returnSelf3 => ProtoObject := self.
		}.
		
		ProtoObject
	') unwrapMbndValue.
	semanticModule finishSemanticAnalysis.

	methodDictionaryContent := protoObjectClass methodDictionaryContent.
	self assert: methodDictionaryContent tally equals:  4.
	self assert: methodDictionaryContent keys size >= 4.
	self assert: methodDictionaryContent values size >= 4.
	
	methodDictionaryObject := protoObjectClass methodDictionaryInstanceObject.
	self assert: (methodDictionaryObject getFieldValue: #tally) unwrapMbndValue equals: 4.
	self assert: (methodDictionaryObject getFieldValue: #array) unwrapMbndValue equals: methodDictionaryContent keys.
	self assert: (methodDictionaryObject getFieldValue: #values) unwrapMbndValue equals: methodDictionaryContent values.
]

{ #category : #tests }
MbndSysmelLanguageSemanticEvaluationTest >> testGCClassVTable [
	| sampleClass |
	self evaluateMiniObjectModelRuntime.
	sampleClass := (self evaluateSource: '
		gcclass SampleClass definition: {
			virtual method myYourself := self.
		}.
		
		SampleClass
	') unwrapMbndValue.
	semanticModule finishSemanticAnalysis.

	self assert: sampleClass supertype name equals: #Object.
	self assert: sampleClass slotLayout virtualTables size equals: 1.
]
