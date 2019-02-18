Extension { #name : #SAsmBinaryObject }

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> buildSysmelImageOn: builder [
	sections do: [ :section |
		builder addBinaryObjectSection: section
	].

	symbols do: [ :symbol |
		builder addBinaryObjectSymbol: symbol
	].

	sections do: [ :section |
		builder convertSectionRelocations: section
	]
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> generateSysmelImage32 [
	| stream |
	stream := SAsmLirBinaryStream on: (ByteArray new: 100).
	self writeSysmelImage32ToStream: stream.
	^ stream contents
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> generateSysmelImage64 [
	| stream |
	stream := SAsmLirBinaryStream on: (ByteArray new: 100).
	self writeSysmelImage64ToStream: stream.
	^ stream contents
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> writeSysmelImage32ToFileNamed: aFileName [
	aFileName asFileReference binaryWriteStreamDo: [ :out |
		out
			truncate;
			nextPutAll: self generateSysmelImage32
	]
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> writeSysmelImage32ToStream: stream [
	| builder |
	builder := SYMLImageFileBuilder32 new.
	self buildSysmelImageOn: builder.
	builder writeToStream: stream
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> writeSysmelImage64ToFileNamed: aFileName [
	aFileName asFileReference binaryWriteStreamDo: [ :out |
		out
			truncate;
			nextPutAll: self generateSysmelImage64
	]
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> writeSysmelImage64ToStream: stream [
	| builder |
	builder := SYMLImageFileBuilder64 new.
	self buildSysmelImageOn: builder.
	builder writeToStream: stream
]

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObject >> writeSysmelImageToFileNamed: aFileReference [
	compilationTarget pointerSize = 4 ifTrue: [
		^ self writeSysmelImage32ToFileNamed: aFileReference
	] ifFalse: [
		^ self writeSysmelImage64ToFileNamed: aFileReference
	]
]
