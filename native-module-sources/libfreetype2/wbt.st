self platform name selectCase: {
    #linux -> [
        self importLibrary: 'freetype' fromDebianPackage: 'libfreetype6-dev'.
    ].
    #osx -> [

    ].
    #windows -> [
        | folder |
        folder := 'windows/' , self architecture name.
        self importLibrary: 'freetype' fromLibFolder: folder , '/lib' binFolder: folder , '/bin'
    ].
    [true] -> []
}.
