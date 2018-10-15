Class {
	#name : #'SYMLGAS_X86LanguageCompiler',
	#superclass : #SYMLScapedLanguageCompiler,
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLGAS_X86LanguageCompiler class >> languageName [
	^ #GAS_X86
]

{ #category : #styling }
SYMLGAS_X86LanguageCompiler >> semanticAnalyzeNode: node inEnvironment: anEnvironment [
	| source gasSource |
	source := node sourceCode withUnixLineEndings.
	gasSource := source copyFrom: 2 to: source size - 1.
	^ (SYMLAPSGInlineAssembly new
		architecture: #x86;
		language: #gas;
		sourceCode: gasSource) semanticAnalysisInEnvironment: anEnvironment
]

{ #category : #styling }
SYMLGAS_X86LanguageCompiler >> style: token into: commands [
]
