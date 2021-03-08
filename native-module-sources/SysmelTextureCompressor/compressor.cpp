#include "compressor.hpp"
#include "libtxc_dxtn/txc_dxtn.h"
#include "rg_etc1.h"

namespace SysmelTextureCompressor
{

static bool isValidUncompressedFormat(PixelFormat format)
{
    switch(format)
    {
    case PixelFormat::R8G8B8A8_Typeless:
    case PixelFormat::R8G8B8A8_UNorm:
    case PixelFormat::R8G8B8A8_UNormSRGB:
    case PixelFormat::R8G8B8_UNorm:
    case PixelFormat::R8G8_Typeless:
    case PixelFormat::R8G8_UNorm:
    case PixelFormat::R8_Typeless:
    case PixelFormat::R8_UNorm:
        return true;
    default:
        return false;
    }
}

static int getPixelFormatComponents(PixelFormat format)
{
    switch(format)
    {
    case PixelFormat::R8G8B8A8_Typeless:
    case PixelFormat::R8G8B8A8_UNorm:
    case PixelFormat::R8G8B8A8_UNormSRGB:
        return 4;
    case PixelFormat::R8G8B8_UNorm:
        return 3;
    case PixelFormat::R8G8_Typeless:
    case PixelFormat::R8G8_UNorm:
        return 2;
    case PixelFormat::R8_Typeless:
    case PixelFormat::R8_UNorm:
        return 1;
    default:
        return 0;
    }
}

bool sysmel_textureCompressor_compressTextureSlice(
    uint32_t width, uint32_t height, PixelFormat sourceFormat, int32_t sourcePitch, const uint8_t *sourcePixels,
    PixelFormat destFormat, int32_t destPitch, uint8_t *destPixels)
{
    (void)sourcePitch;
    if(!isValidUncompressedFormat(sourceFormat))
        return false;

    switch(destFormat)
    {
    case PixelFormat::BC1_Typeless:
    case PixelFormat::BC1_UNorm:
    case PixelFormat::BC1_UNormSRGB:
        tx_compress_dxtn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, GL_COMPRESSED_RGBA_S3TC_DXT1_EXT,
                  destPixels, destPitch);
        return true;
    case PixelFormat::BC2_Typeless:
    case PixelFormat::BC2_UNorm:
    case PixelFormat::BC2_UNormSRGB:
        tx_compress_dxtn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, GL_COMPRESSED_RGBA_S3TC_DXT3_EXT,
                  destPixels, destPitch);
        return true;

    case PixelFormat::BC3_Typeless:
    case PixelFormat::BC3_UNorm:
    case PixelFormat::BC3_UNormSRGB:
        tx_compress_dxtn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, GL_COMPRESSED_RGBA_S3TC_DXT5_EXT,
                  destPixels, destPitch);
        return true;
    default:
        return false;
    }
}


typedef void (*FetchTexelFunction) (GLint srcRowStride, const GLubyte *pixdata, GLint i, GLint j, GLvoid *texel);

static void decompressDxtnTextureSliceWith(
    uint32_t width, uint32_t height, int32_t sourcePitch, const uint8_t *sourcePixels,
    PixelFormat destFormat, int32_t destPitch, uint8_t *destPixels,
    FetchTexelFunction fetchTexelFunction
)
{
    (void)sourcePitch;
    uint8_t decodedTexel[4];

    auto destRow = destPixels;
    auto pixelSize = getPixelFormatComponents(destFormat);
    for(uint32_t y = 0; y < height; ++y)
    {
        auto destPixel = destRow;
        for(uint32_t x = 0; x < width; ++x)
        {
            fetchTexelFunction(width, sourcePixels, x, y, decodedTexel);
            for(int i = 0; i < pixelSize; ++i)
                destPixel[i] = decodedTexel[i];
            destPixel += pixelSize;
        }

        destRow += destPitch;
    }
}

bool sysmel_textureCompressor_decompressTextureSlice(
    uint32_t width, uint32_t height, PixelFormat sourceFormat, int32_t sourcePitch, const uint8_t *sourcePixels,
    PixelFormat destFormat, int32_t destPitch, uint8_t *destPixels)
{
    if(!isValidUncompressedFormat(destFormat))
        return false;

    switch(sourceFormat)
    {
    case PixelFormat::BC1_Typeless:
    case PixelFormat::BC1_UNorm:
    case PixelFormat::BC1_UNormSRGB:
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, fetch_2d_texel_rgba_dxt1);
        return true;
    case PixelFormat::BC2_Typeless:
    case PixelFormat::BC2_UNorm:
    case PixelFormat::BC2_UNormSRGB:
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, fetch_2d_texel_rgba_dxt3);
        return true;
    case PixelFormat::BC3_Typeless:
    case PixelFormat::BC3_UNorm:
    case PixelFormat::BC3_UNormSRGB:
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, fetch_2d_texel_rgba_dxt5);
        return true;
    default:
        return false;
    }
}
} // End of namespace namespace SysmelTextureCompressor
