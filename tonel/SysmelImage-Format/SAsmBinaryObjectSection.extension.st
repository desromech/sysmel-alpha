Extension { #name : #SAsmBinaryObjectSection }

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObjectSection >> convertSymbol: originalSymbol intoSysmelImageSymbolEntry: symbolEntry with: imageBuilder [
	symbolEntry
		sectionDescriptor: (imageBuilder sectionDescriptorFor: originalSymbol section);
		sectionOffset: originalSymbol value

]
