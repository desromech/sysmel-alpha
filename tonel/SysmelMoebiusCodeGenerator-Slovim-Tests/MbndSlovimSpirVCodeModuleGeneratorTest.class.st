Class {
	#name : #MbndSlovimSpirVCodeModuleGeneratorTest,
	#superclass : #MbndSlovimCodeModuleGeneratorCommonTest,
	#instVars : [
		'spirvModule'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Tests-Module'
}

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> generateSpirV [
	spirvModule := ssaModule asLowLevelModule.
	self flag: 'TODO: use spirv-val, if available.'
]

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> setUp [
	semanticModule := MbndStandaloneModule spirv_vulkan.
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderIO [
	| shaderController |
	self evaluateSysmelSource: '
struct ShaderIO definition: {
	public field color type: Float32x4; location: 0.
}.

function shader fragmentShader externC(stageIn: ShaderIO inputChannel, stageOut: ShaderIO outputChannel) => Void := { 
	stageOut send: stageIn receive
}
';
	generateSSAModule;
	validateSpirV.
	
	shaderController := ssaModule globalNamed: #shader.
	self assert: shaderController allInstructionsMnemonics equals: #(
		(entry (
			alloca
			alloca
			load
			getElementPointer
			store
			call
			getElementPointer
			load
			store
			returnVoid
		))
	).
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderNop [
	| shaderController |
	self evaluateSysmelSource: '
function shader fragmentShader externC() => Void := { 
}
';
	generateSSAModule;
	validateSpirV.
	
	shaderController := ssaModule globalNamed: #shader.
	self assert: shaderController allInstructionsMnemonics equals: #(
		(entry (
			call
			returnVoid
		))
	).
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderSampleTextureColor [
	| shaderImplementation |
	self evaluateSysmelSource: '
struct Input definition: {
	public field texcoord type: Float32x2; location: 0.
}.

struct Output definition: {
	public field color type: Float32x4; location: 0.
}.

class Samplers definition: {
    public field sampler type: GPUSampler.
}.

class TexturingState definition: {
    public field texture type: GPUTexture2D.
}.

class ShaderInterface definition: {
	field samplerState type: Samplers bindingSetPointer.
	field texturingState type: TexturingState bindingSetPointer.

	function shader fragmentShader externC(stageIn: Input inputChannel, stageOut: Output outputChannel) => Void := { 
		let color := samplerState _ sampler
							sample: texturingState _ texture at: stageIn receive texcoord.
		stageOut send: (Output newValue color: color)
	}
}.

';
	generateSSAModule;
	validateSpirV.
	
	shaderImplementation := ssaModule globalNamed: #_S15ShaderInterface6shaderFRTc_S15ShaderInterfaceTCiTs_S5InputTCoTs_S6Output_impl.
	self assert: shaderImplementation allInstructionsMnemonics equals: #(
		(entry (
			jump
		))
		(body (
			load
			load
			load
			extractValue
			combineSamplerWithTexture
			sampleImplicitLOD
			insertValue
			store
			returnVoid
		))
	)
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderSampleTextureColorWithDerivatives [
	| shaderImplementation |
	self evaluateSysmelSource: '
struct Input definition: {
	public field texcoord type: Float32x2; location: 0.
}.

struct Output definition: {
	public field color type: Float32x4; location: 0.
}.

class Samplers definition: {
    public field sampler type: GPUSampler.
}.

class TexturingState definition: {
    public field texture type: GPUTexture2D.
}.

class ShaderInterface definition: {
	field samplerState type: Samplers bindingSetPointer.
	field texturingState type: TexturingState bindingSetPointer.

	function shader fragmentShader externC(stageIn: Input inputChannel, stageOut: Output outputChannel) => Void := { 
		let color := samplerState _ sampler
							sample: texturingState _ texture at: stageIn receive texcoord dtdx: Float32x2(0.0, 0.0) dtdy: Float32x2(0.0, 0.0).
		stageOut send: (Output newValue color: color)
	}
}.

';
	generateSSAModule;
	validateSpirV.
	
	shaderImplementation := ssaModule globalNamed: #_S15ShaderInterface6shaderFRTc_S15ShaderInterfaceTCiTs_S5InputTCoTs_S6Output_impl.
	self assert: shaderImplementation allInstructionsMnemonics equals: #(
		(entry (
			jump
		))
		(body (
			load
			load
			load
			extractValue
			combineSamplerWithTexture
			sampleExplicitGradient
			insertValue
			store
			returnVoid
		))
	)
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderSampleTextureColorWithLod [
	| shaderImplementation |
	self evaluateSysmelSource: '
struct Input definition: {
	public field texcoord type: Float32x2; location: 0.
}.

struct Output definition: {
	public field color type: Float32x4; location: 0.
}.

class Samplers definition: {
    public field sampler type: GPUSampler.
}.

class TexturingState definition: {
    public field texture type: GPUTexture2D.
}.

class ShaderInterface definition: {
	field samplerState type: Samplers bindingSetPointer.
	field texturingState type: TexturingState bindingSetPointer.

	function shader fragmentShader externC(stageIn: Input inputChannel, stageOut: Output outputChannel) => Void := { 
		let color := samplerState _ sampler
							sample: texturingState _ texture at: stageIn receive texcoord lod: 0.0.
		stageOut send: (Output newValue color: color)
	}
}.

';
	generateSSAModule;
	validateSpirV.
	
	shaderImplementation := ssaModule globalNamed: #_S15ShaderInterface6shaderFRTc_S15ShaderInterfaceTCiTs_S5InputTCoTs_S6Output_impl.
	self assert: shaderImplementation allInstructionsMnemonics equals: #(
		(entry (
			jump
		))
		(body (
			load
			load
			load
			extractValue
			combineSamplerWithTexture
			sampleExplicitLOD
			insertValue
			store
			returnVoid
		))
	)
]

{ #category : #tests }
MbndSlovimSpirVCodeModuleGeneratorTest >> testFragmentShaderSolidColorIO [
	| shaderController |
	self evaluateSysmelSource: '
struct ShaderIO definition: {
	public field color type: Float32x4; location: 0.
}.

function shader fragmentShader externC(stageOut: ShaderIO outputChannel) => Void := { 
	stageOut send: (ShaderIO newValue color: Float32x4(1.0, 0.0, 0.0, 1.0))
}
';
	generateSSAModule;
	validateSpirV.
	
	shaderController := ssaModule globalNamed: #shader.
	self assert: shaderController allInstructionsMnemonics equals: #(
		(entry (
			alloca
			call
			getElementPointer
			load
			store
			returnVoid
		))
	).
]

{ #category : #running }
MbndSlovimSpirVCodeModuleGeneratorTest >> validateSpirV [
	self generateSpirV
]
