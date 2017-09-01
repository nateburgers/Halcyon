/**
 * @file hls_integer.hh
 * @brief Provides integer types with explicit sizes
 */

#pragma once
#include <cstdint>

namespace Halcyon {
namespace hls {

/**
 * @class Integer8
 * @brief 8-bit signed integer
 */
using Integer8 = std::int8_t;

/**
 * @class Integer16
 * @brief 16-bit signed integer
 */
using Integer16 = std::int16_t;

/**
 * @class Integer32
 * @brief 32-bit signed integer
 */
using Integer32 = std::int32_t;

/**
 * @class Integer64
 * @brief 64-bit signed integer
 */
using Integer64 = std::int64_t;

/**
 * @class Integer
 * @brief 64-bit signed integer
 */
using Integer = std::int64_t;
}
}
