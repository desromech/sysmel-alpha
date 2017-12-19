tokens
floatNumber
	^ self token: numberSign optional, #digit asParser plus, $. asParser , #digit asParser plus , (numberEMark , numberSign optional, #digit asParser plus) optional