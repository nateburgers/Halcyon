/// @file hls_buffer.hh
/// Provide a POD type that contains uninitialized storage for any other value.
#pragma once

#include <type_traits>

namespace Halcyon {
namespace hls {

template <typename VALUE_TYPE>
class Buffer
{
  public:
    // TYPES
    using Value = VALUE_TYPE;

  private:
    alignas(alignof(Value)) unsigned char d_buffer[sizeof(Value)];

  public:
    // CREATORS
    constexpr Buffer() = default;

    constexpr Buffer(const Buffer& original) = default;

    constexpr Buffer(Buffer&& original) = default;

    constexpr Buffer(const Value& value);

    constexpr Buffer(Value&& value);

    template <typename... CONSTRUCTION_PARAMETERS>
    constexpr Buffer(CONSTRUCTION_PARAMETERS&&... parameters);

    ~Buffer() = default;

    // MANIPULATORS
    Buffer& operator=(const Buffer& original) = default;

    Buffer& operator=(Buffer&& original) = default;

    Buffer& operator=(const Value& original);

    Buffer& operator=(Value&& original);

    template <typename... CONSTRUCTION_PARAMETERS>
    void createInPlace(CONSTRUCTION_PARAMETERS&&... parameters);

    void destroy();

    Value& value();

    // ACCESSORS
    const Value& value() const;
};

/// @section Inline Definitions

// CREATORS
template <typename VALUE_TYPE>
constexpr Buffer<VALUE_TYPE>::Buffer(const VALUE_TYPE& value)
{
    new (&d_buffer) VALUE_TYPE(value);
}

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
