self platform name selectCase: {
    #linux -> [
        self importLibrary: 'png' fromDebianPackage: 'libpng-dev'.
    ].
    #osx -> [
        self importLibrary: 'png'
    ].
    #windows -> [
        | folder |
        folder := 'windows/' , self architecture name.
        self importLibrary: 'libpng16' fromLibFolder: folder , '/lib' binFolder: folder , '/bin'
    ].
    [true] -> []
}.
