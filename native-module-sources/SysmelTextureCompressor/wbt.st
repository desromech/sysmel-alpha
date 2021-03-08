self staticLibrary: 'SysmelTextureCompressor' with: [:lib |
    lib sources: #(
        'compressor.cpp'
        'rg_etc1.cpp'
        'libtxc_dxtn/txc_compress_dxtn.c'
        'libtxc_dxtn/txc_fetch_dxtn.c'
    )
]
