Class {
	#name : #MbndAbstractConcreteCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'instance creation' }
MbndAbstractConcreteCompilationTarget class >> for: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget
]

{ #category : #serialization }
MbndAbstractConcreteCompilationTarget class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	self assert: objectType = #CompilationTarget.
	graphDecoder registerObjectInstance: graphDecoder compilationTarget.
	graphDecoder decodeNext.
	^ graphDecoder compilationTarget
]

{ #category : #'derived types' }
MbndAbstractConcreteCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
]

{ #category : #serialization }
MbndAbstractConcreteCompilationTarget >> encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder [
	^ Array streamContents: [:out |
		#(
			"Embedded shaders"
			shaderEntryPointInfo shaderModuleInfo
			
			"Shader CPU simulation"
			nativeComputeShaderIOInterface nativeVertexShaderIOInterface nativeFragmentShaderIOInterface 			nativeGeometryShaderIOInterface nativeTessellationControlShaderIOInterface
			nativeTessellationEvaluationShaderIOInterface
			sampleTextureImplicitLodFunction sampleTextureExplicitLodFunction sampleTextureExplicitDerivativesFunction
			
			"RTTI"
			typeInformationNativeClass typeInformationGCClass 
			moduleNamespaceInformationNativeClass moduleNamespaceInformationGCClass 
			moduleInformationNativeClass moduleInformationGCClass
			
			extensionMacroMessageGCClass extensionMacroMessageNativeClass
			extensionOverloadedMethodGCClass extensionOverloadedMethodNativeClass
			extensionMethodGCClass extensionMethodNativeClass
			
			"Static constructors/destructors"
			sysmelAtExitFunction
			
			"EH"
			exceptionContextType
			#exceptionCleanUpEndFunction
			#exceptionContextBeginFunction
			#exceptionContextEndFunction
			exceptionSetjmpFunction
			exceptionLongjmpFunction

			exceptionCatchBeginFunction
			exceptionCatchEndFunction
			forbiddenExceptionHandlingFunction
			internalNonLocalReturnExceptionClass
			personalityFunction
			nonLocalReturnCatchFunction
			nonLocalReturnRaiseFunction
			patternMatchingFailureRaiseFunction
			variantUnexpectedComponentRaiseFunction
			indexOutOfBoundsRaiseFunction
			
			"GC runtime"
			defaultGCClassSuperClass
			dynamicObjectType
		) do: [ :selector |
			out nextPut: selector; nextPut: ((self perform: selector) encodeGraphForMessagePackWith: graphEncoder)
		].
	
		out nextPut: #managedObjectModel; nextPut: (managedObjectModel encodeBootstrapDefinedObjectsForMessagePackWith: graphEncoder)
	].

]

{ #category : #'convenience type accessors' }
MbndAbstractConcreteCompilationTarget >> patternMatchingPatternType [
	^ self getBasicTypeNamed: MbndPatternMatchingPatternType typeName
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerSize [
	self subclassResponsibility
]
