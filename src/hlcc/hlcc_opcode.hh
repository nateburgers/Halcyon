/// @file hlcc_opcode.hh
#pragma once

#include <hls_integer.hh>

namespace Halcyon {
namespace hlcc {

/// @enum Opcode
enum class Opcode : hls::Integer
{
    // ENUMERATORS
    e_NO_OPERATION      = 0x0000,
    e_INTEGER32_ADD     = 0x0001,
    e_INTEGER32_SUBRACT = 0x0002,
};

}
}
