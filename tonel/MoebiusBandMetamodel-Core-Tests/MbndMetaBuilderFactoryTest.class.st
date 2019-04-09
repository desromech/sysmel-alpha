"
A MbndMetaBuilderFactoryTest is a test class for testing the behavior of MbndMetaBuilderFactory
"
Class {
	#name : #MbndMetaBuilderFactoryTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-MetaBuilder'
}

{ #category : #tests }
MbndMetaBuilderFactoryTest >> testFactoryReference [
	| module analyzer factory reference instanceNode |
	module := MbndDummyModule new.
	analyzer := module newGenericSemanticAnalyzer.
	factory := MbndMetaBuilderFactory new metaBuilderClass: MbndMetaBuilder.
	reference := MbndAstIdentifierReferenceNode new.
	instanceNode := factory analyzeReferenceNode: reference with: analyzer.
	self assert: instanceNode position equals: reference.
	self assert: instanceNode type isMetaBuilderInstanceType.
	self assert: instanceNode instance class equals: MbndMetaBuilder.
	self assert: instanceNode instance position equals: reference.
	self assert: instanceNode instance metaBuilderAnalyzer equals: analyzer.
	self assert: instanceNode instance metaBuilderScope equals: analyzer scope.

]
