Class {
	#name : #MbndSlovimCodeModuleGeneratorCommonTest,
	#superclass : #MbndSysmelLanguageTestCommon,
	#instVars : [
		'ssaModule'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Tests-Module'
}

{ #category : #testing }
MbndSlovimCodeModuleGeneratorCommonTest class >> isAbstract [
	^ self  == MbndSlovimCodeModuleGeneratorCommonTest
]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGeneratorCommonTest >> disableExceptions [
	semanticModule noExceptions
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorCommonTest >> generateSSAModule [
	semanticModule finishSemanticAnalysis.
	ssaModule := semanticModule generateTargetCodeModule.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorCommonTest >> setUp [
	semanticModule := MbndStandaloneModule llvm_x86_64.
]
