Class {
	#name : #MbndReferenceEntity,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #serialization }
MbndReferenceEntity class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	| result |
	objectType = #ReferenceMetaType ifTrue: [
		self assert: earlyFields isMbndType.
		result := earlyFields type
	].

	objectType = #ReferenceGlobalNamespace ifTrue: [
		result := earlyFields globalNamespace.
	].

	objectType = #ReferenceTemplateInstance ifTrue: [
		result := earlyFields first getExistingInstanceWithArguments: earlyFields second
	].

	objectType = #ReferenceMainChild ifTrue: [ 
		result := earlyFields mainChild
	].

	objectType = #ReferenceNamedChild ifTrue: [
		result := earlyFields first findChildWithMessagePackTypeName: earlyFields second named: earlyFields third.
	].

	objectType = #ReferenceFieldChild ifTrue: [
		result := earlyFields first findFieldChildWithMessagePackTypeName: earlyFields second slotIndex: earlyFields third bitOffset: earlyFields fourth.
	].

	result ifNil: [ self error: 'Failed to decode referenced program entity.' ].
	graphDecoder registerObjectInstance: result.
	graphDecoder decodeNext.

	^ result
]
