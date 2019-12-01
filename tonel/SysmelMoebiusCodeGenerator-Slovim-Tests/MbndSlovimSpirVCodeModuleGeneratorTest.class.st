Class {
	#name : #MbndSlovimSpirVCodeModuleGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'semanticModule',
		'ssaModule',
		'spirvModule'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Tests-Module'
}

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> evaluateSysmelSource: sourceString [
	semanticModule evaluateLanguage: #sysmel source: sourceString.
]

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> generateSSAModule [
	semanticModule finishSemanticAnalysis.
	ssaModule := semanticModule generateTargetCodeModule.
]

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> generateSpirV [
	spirvModule := ssaModule asLowLevelModule
]

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> setUp [
	semanticModule := MbndStandaloneModule spirv_vulkan.
]
