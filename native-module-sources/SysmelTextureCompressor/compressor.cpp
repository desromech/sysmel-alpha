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

static void compressEtc1(int sourcePixelSize, int width, int height, int sourcePitch, const uint8_t *sourceData, uint8_t *dest, GLint destPitch, bool addAlpha = false)
{
    // FIXME: wrap this call in std::once_flag
    rg_etc1::pack_etc1_block_init();

    rg_etc1::etc1_pack_params packParams;
    packParams.m_quality = rg_etc1::cMediumQuality;

    uint8_t readedBlock[4][4][4];
    uint8_t colorPackBlock[4][4][4];

    auto destRow = dest;
    auto sourceRow = sourceData;
    for (int ry = 0; ry < height; ry += 4)
    {
        auto blockHeight = (height > ry + 3) ? 4 : height - ry;
        auto sourcePixel = sourceRow;
        auto destPixel = destRow;
        for (int rx = 0; rx < width; rx += 4)
        {
            auto blockWidth = (width > rx + 3) ? 4 : width - rx;

            // Clear the readed block data.
            memset(readedBlock, 0, sizeof(readedBlock));

            // Read the block data.
            auto blockSourcePixelRow = sourcePixel;
            for(int j = 0; j < blockHeight; ++j)
            {
                auto blockSourcePixel = blockSourcePixelRow;
                for(int i = 0; i < blockWidth; ++i)
                {
                    for(int k = 0; k < sourcePixelSize; ++k)
                        readedBlock[j][i][k] = blockSourcePixel[k];
                    blockSourcePixel += sourcePixelSize;
                }

                blockSourcePixelRow += sourcePitch;
            }

            // Encode the optional alpha component.
            if(addAlpha)
            {
                *destPixel++ = (readedBlock[0][0][3] >> 4) | (readedBlock[0][1][3] & 0xf0);
                *destPixel++ = (readedBlock[0][2][3] >> 4) | (readedBlock[0][3][3] & 0xf0);
                *destPixel++ = (readedBlock[1][0][3] >> 4) | (readedBlock[1][1][3] & 0xf0);
                *destPixel++ = (readedBlock[1][2][3] >> 4) | (readedBlock[1][3][3] & 0xf0);
                *destPixel++ = (readedBlock[2][0][3] >> 4) | (readedBlock[2][1][3] & 0xf0);
                *destPixel++ = (readedBlock[2][2][3] >> 4) | (readedBlock[2][3][3] & 0xf0);
                *destPixel++ = (readedBlock[3][0][3] >> 4) | (readedBlock[3][1][3] & 0xf0);
                *destPixel++ = (readedBlock[3][2][3] >> 4) | (readedBlock[3][3][3] & 0xf0);
            }

            // Copy and clear the alpha for encoding the color data.
            memcpy(colorPackBlock, readedBlock, sizeof(readedBlock));
            for(int j = 0; j < 4; ++j)
            {
                for(int i = 0; i < 4; ++i)
                    colorPackBlock[j][i][3] = 255;
            }

            // Encode the ETC1 color data.
            rg_etc1::pack_etc1_block(destPixel, reinterpret_cast<const unsigned int*> (readedBlock), packParams);

            // Advance to the next block.
            sourcePixel += sourcePixelSize*4;
            destPixel += 8;
        }

        sourceRow += sourcePitch*4;
        destRow += destPitch;
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
        sysmel_txc_tx_compress_bcn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, 1,
                  destPixels, destPitch);
        return true;
    case PixelFormat::BC2_Typeless:
    case PixelFormat::BC2_UNorm:
    case PixelFormat::BC2_UNormSRGB:
        sysmel_txc_tx_compress_bcn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, 2,
                  destPixels, destPitch);
        return true;

    case PixelFormat::BC3_Typeless:
    case PixelFormat::BC3_UNorm:
    case PixelFormat::BC3_UNormSRGB:
        sysmel_txc_tx_compress_bcn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, 3,
                  destPixels, destPitch);
        return true;

    case PixelFormat::BC4_Typeless:
    case PixelFormat::BC4_UNorm:
        sysmel_txc_tx_compress_bcn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, 4,
                  destPixels, destPitch);
        return true;
    case PixelFormat::BC5_Typeless:
    case PixelFormat::BC5_UNorm:
        sysmel_txc_tx_compress_bcn(getPixelFormatComponents(sourceFormat), width, height,
                  sourcePixels, 5,
                  destPixels, destPitch);
        return true;
    case PixelFormat::ETC1_R8G8B8_UNorm:
    case PixelFormat::ETC1_R8G8B8_UNormSRGB:
        compressEtc1(getPixelFormatComponents(sourceFormat), width, height, sourcePitch, sourcePixels, destPixels, destPitch, false);
        return true;
    case PixelFormat::ETC1_R8G8B8A4_UNorm:
    case PixelFormat::ETC1_R8G8B8A4_UNormSRGB:
        compressEtc1(getPixelFormatComponents(sourceFormat), width, height, sourcePitch, sourcePixels, destPixels, destPitch, true);
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
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, sysmel_txc_fetch_2d_texel_rgba_bc1);
        return true;
    case PixelFormat::BC2_Typeless:
    case PixelFormat::BC2_UNorm:
    case PixelFormat::BC2_UNormSRGB:
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, sysmel_txc_fetch_2d_texel_rgba_bc2);
        return true;
    case PixelFormat::BC3_Typeless:
    case PixelFormat::BC3_UNorm:
    case PixelFormat::BC3_UNormSRGB:
        decompressDxtnTextureSliceWith(width, height, sourcePitch, sourcePixels, destFormat, destPitch, destPixels, sysmel_txc_fetch_2d_texel_rgba_bc3);
        return true;
    default:
        return false;
    }
}
} // End of namespace namespace SysmelTextureCompressor
