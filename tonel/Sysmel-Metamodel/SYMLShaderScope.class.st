Class {
	#name : #SYMLShaderScope,
	#superclass : #SYMLAbstractTypeScope,
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLShaderScope >> addShaderVariable: variable at: aPosition [
	^ programEntity addShaderVariable: variable at: aPosition
]

{ #category : #accessing }
SYMLShaderScope >> fillSymbols [
	super fillSymbols.
	symbols
		at: #descriptorSet put: (SYMLMetaBuilder for: SYMLShaderDescriptorSet module: programEntity module parent: programEntity);
		at: #stageio put: (SYMLMetaBuilder for: SYMLShaderStageIO module: programEntity module parent: programEntity);
		at: #uniform put: (SYMLMetaBuilder for: SYMLShaderUniformVariable module: programEntity module parent: programEntity);
		at: #buffer put: (SYMLMetaBuilder for: SYMLShaderBufferVariable module: programEntity module parent: programEntity);
		
		at: #vertex put: (SYMLMetaBuilder for: SYMLVertexShaderStage module: programEntity module parent: programEntity);
		at: #fragment put: (SYMLMetaBuilder for: SYMLFragmentShaderStage module: programEntity module parent: programEntity);
		at: #geometry put: (SYMLMetaBuilder for: SYMLGeometryShaderStage module: programEntity module parent: programEntity);
		at: #compute put: (SYMLMetaBuilder for: SYMLComputeShaderStage module: programEntity module parent: programEntity);
		at: #tesscontrol put: (SYMLMetaBuilder for: SYMLTessellationControlShaderStage module: programEntity module parent: programEntity);
		at: #tesseval put: (SYMLMetaBuilder for: SYMLTessellationEvaluationShaderStage module: programEntity module parent: programEntity);
		yourself
]
