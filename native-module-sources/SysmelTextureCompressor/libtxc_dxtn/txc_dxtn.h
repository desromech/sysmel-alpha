/*
 * libtxc_dxtn
 * Version:  0.1
 *
 * Copyright (C) 2004  Roland Scheidegger   All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * BRIAN PAUL BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
/**
 * Modifications by Ronie Salgado:
 * - Remove dependency on glext, use the bc index as an identification for the format itself.
 */
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif
#include <GL/gl.h>

typedef GLubyte GLchan;
#define UBYTE_TO_CHAN(b)  (b)
#define CHAN_MAX 255
#define RCOMP 0
#define GCOMP 1
#define BCOMP 2
#define ACOMP 3

#ifdef __cplusplus
extern "C" {
#endif

void sysmel_txc_fetch_2d_texel_rgba_bc1(GLint srcRowStride, const GLubyte *pixdata,
			     GLint i, GLint j, GLvoid *texel);
void sysmel_txc_fetch_2d_texel_rgba_bc2(GLint srcRowStride, const GLubyte *pixdata,
			     GLint i, GLint j, GLvoid *texel);
void sysmel_txc_fetch_2d_texel_rgba_bc3(GLint srcRowStride, const GLubyte *pixdata,
			     GLint i, GLint j, GLvoid *texel);

void sysmel_txc_tx_compress_bcn(GLint srccomps, GLint width, GLint height,
		      const GLubyte *srcPixData, int bcn,
		      GLubyte *dest, GLint dstRowStride);

#ifdef __cplusplus
}
#endif
