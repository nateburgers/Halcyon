/// @file hls_natural.hh
/// Provide unsigned integer types with explicit sizes.
#pragma once

#include <cstdint>

namespace Halcyon {
namespace hls {

/// 8-bit unsigned integer
using Natural8 = std::uint8_t;

/// 16-bit unsigned integer
using Natural16 = std::uint16_t;

/// 32-bit unsigned integer
using Natural32 = std::uint32_t;

/// 64-bit unsigned integer
using Natural64 = std::uint64_t;

/// 64-bit unsigned integer
using Natural = std::uint64_t;

}
}

//-----------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2017 Nathan Burgers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//-----------------------------------------------------------------------------
