Class {
	#name : #SYMLMethodBuilder,
	#superclass : #SYMLFunctionBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #private }
SYMLMethodBuilder >> constructFunction [
	^ SYMLMethod new
		name: name;
		module: definitionEnvironment module;
		functionType: self functionType;
		argumentNames: (arguments collect: #first);
		argumentNodes: (arguments collect: #third);
		flags: flags;
		yourself.
]
