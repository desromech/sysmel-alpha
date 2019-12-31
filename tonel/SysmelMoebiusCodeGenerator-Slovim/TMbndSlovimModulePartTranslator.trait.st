Trait {
	#name : #TMbndSlovimModulePartTranslator,
	#instVars : [
		'codeModuleGenerator'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
TMbndSlovimModulePartTranslator >> codeModuleGenerator [
	^ codeModuleGenerator
]

{ #category : #accessing }
TMbndSlovimModulePartTranslator >> codeModuleGenerator: anObject [
	codeModuleGenerator := anObject
]

{ #category : #accessing }
TMbndSlovimModulePartTranslator >> compilationTarget [
	^ codeModuleGenerator compilationTarget
]

{ #category : #testing }
TMbndSlovimModulePartTranslator >> isEmittingDebugInformation [
	^ codeModuleGenerator isEmittingDebugInformation
]

{ #category : #'as yet unclassified' }
TMbndSlovimModulePartTranslator >> sanitizeStructureFieldType: type [
	^ codeModuleGenerator sanitizeStructureFieldType: type
]

{ #category : #'as yet unclassified' }
TMbndSlovimModulePartTranslator >> sanitizeValueTypeForMemory: type [
	^ codeModuleGenerator sanitizeValueTypeForMemory: type
]

{ #category : #accessing }
TMbndSlovimModulePartTranslator >> slvmCompilationTarget [
	^ codeModuleGenerator slvmCompilationTarget
]

{ #category : #'as yet unclassified' }
TMbndSlovimModulePartTranslator >> sourceModule [
	^ codeModuleGenerator sourceModule
]

{ #category : #'as yet unclassified' }
TMbndSlovimModulePartTranslator >> ssaModule [
	^ codeModuleGenerator ssaModule
]

{ #category : #'code generation' }
TMbndSlovimModulePartTranslator >> translateDebugType: aType [
	^ codeModuleGenerator translateDebugType: aType	
]

{ #category : #'code generation' }
TMbndSlovimModulePartTranslator >> translateProgramEntity: aProgramEntity [
	^ codeModuleGenerator translateProgramEntity: aProgramEntity
]

{ #category : #'code generation' }
TMbndSlovimModulePartTranslator >> translateProgramEntityDebugInformation: aProgramEntity [
	^ codeModuleGenerator translateProgramEntityDebugInformation: aProgramEntity
]

{ #category : #'code generation' }
TMbndSlovimModulePartTranslator >> translateType: aType [
	^ codeModuleGenerator translateType: aType	
]
