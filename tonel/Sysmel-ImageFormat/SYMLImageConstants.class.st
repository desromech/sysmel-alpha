Class {
	#name : #SYMLImageConstants,
	#superclass : #SharedPool,
	#classVars : [
		'SAsmRelocationTypeMap',
		'VTable_Array',
		'VTable_Rela_AbsoluteOffset16',
		'VTable_Rela_AbsoluteOffset32',
		'VTable_Rela_AbsoluteOffset64',
		'VTable_Rela_AbsoluteOffset8',
		'VTable_Rela_AbsoluteSOffset32',
		'VTable_Rela_RelativeBranch32',
		'VTable_Rela_RelativeSOffset16',
		'VTable_Rela_RelativeSOffset32',
		'VTable_Rela_RelativeSOffset32AtGOT',
		'VTable_Rela_RelativeSOffset32GOTOffset',
		'VTable_Rela_RelativeSOffset32GlobalOffsetTable',
		'VTable_Rela_RelativeSOffset64',
		'VTable_Rela_RelativeSOffset8',
		'VTable_Rela_SectionRelativeOffset32',
		'VTable_Rela_SectionRelativeOffset64',
		'VTable_RelocationWithAddend',
		'VTable_SectionDescriptor',
		'VTable_String',
		'VTable_Symbol',
		'VTable_SymbolTable',
		'VTable_SymbolTableEntry'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #'class initialization' }
SYMLImageConstants class >> initialize [

	"These values are used to identify some special loader specific vtable object."
	VTable_Array := -1.
	VTable_Symbol := -2.
	VTable_String := -3.

	VTable_SectionDescriptor := -4.
	VTable_SymbolTable := -5.
	VTable_SymbolTableEntry := -6.

	VTable_Rela_AbsoluteOffset8 := -100.
	VTable_Rela_AbsoluteOffset16 := -101.
	VTable_Rela_AbsoluteOffset32 := -102.
	VTable_Rela_AbsoluteSOffset32 := -103.		
	VTable_Rela_AbsoluteOffset64 := -104.
	
	VTable_Rela_SectionRelativeOffset32 := -105.
	VTable_Rela_SectionRelativeOffset64 := -106.
	
	VTable_Rela_RelativeSOffset8 := -107.
	VTable_Rela_RelativeSOffset16 := -108.
	VTable_Rela_RelativeSOffset32 := -109.
	VTable_Rela_RelativeSOffset64 := -110.

	VTable_Rela_RelativeSOffset32AtGOT := -111.
	VTable_Rela_RelativeSOffset32GOTOffset := -112.
	VTable_Rela_RelativeSOffset32GlobalOffsetTable := -113.
	VTable_Rela_RelativeBranch32 := -114.

	self flag: 'TODO: Clean up this dictionary'.
	SAsmRelocationTypeMap := Dictionary newFromPairs: { 
		#'absolute-offset8' . VTable_Rela_AbsoluteOffset8.
		#'absolute-offset16' . VTable_Rela_AbsoluteOffset16.
		#'absolute-offset32' . VTable_Rela_AbsoluteOffset32.
		#'absolute-soffset32' . VTable_Rela_AbsoluteSOffset32.
		#'absolute-offset64' . VTable_Rela_AbsoluteOffset64.
		
		#'section-relative-offset32' . VTable_Rela_SectionRelativeOffset32.
		#'section-relative-offset64' . VTable_Rela_SectionRelativeOffset64.
	
		#'relative-soffset8' . VTable_Rela_RelativeSOffset8.
		#'relative-soffset16' . VTable_Rela_RelativeSOffset16.
		#'relative-soffset32' . VTable_Rela_RelativeSOffset32.
		#'relative-soffset64' . VTable_Rela_RelativeSOffset64.

		#'relative-soffset32-at-got' . VTable_Rela_RelativeSOffset32AtGOT.
		#'relative-soffset32-got-offset' . VTable_Rela_RelativeSOffset32GOTOffset.
		#'relative-soffset32-global-offset-table' . VTable_Rela_RelativeSOffset32GlobalOffsetTable.
		#'relative-branch32' . VTable_Rela_RelativeBranch32.
	}.


]
