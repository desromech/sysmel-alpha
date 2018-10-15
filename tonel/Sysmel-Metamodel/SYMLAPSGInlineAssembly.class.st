Class {
	#name : #SYMLAPSGInlineAssembly,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'architecture',
		'language',
		'sourceCode',
		'compileTimeAction'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGInlineAssembly >> architecture [
	^ architecture
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> architecture: anObject [
	architecture := anObject
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> compileTimeAction [
	^ compileTimeAction
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> compileTimeAction: anObject [
	compileTimeAction := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGInlineAssembly >> evaluateInEnvironment: anEnvironment [
	^ compileTimeAction ifNotNil: [ compileTimeAction evaluateInEnvironment: anEnvironment ]
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> language [
	^ language
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> language: anObject [
	language := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGInlineAssembly >> semanticAnalysisInEnvironment: anEnvironment [
	anEnvironment isImmediateEnvironment ifTrue: [
		anEnvironment definitionProgramEntity module
			addArchitecture: architecture
			language: language
			inlineAssembly: self sourceCodeString withUnixLineEndings
	].

	compileTimeAction ifNotNil: [
		^ self shallowCopy
			compileTimeAction: (compileTimeAction semanticAnalysisInEnvironment: anEnvironment);
			yourself
	].

	^ self
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #accessing }
SYMLAPSGInlineAssembly >> sourceCodeString [
	^ sourceCode value unwrapSysmelValue
]
