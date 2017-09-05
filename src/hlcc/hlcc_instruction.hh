/// @file hlcc_instruction.hh
#pragma once

#include <hlcc_opcode.hh>
#include <hls_integer.hh>
#include <hls_vector.hh>

namespace Halcyon {
namespace hlcc {

class Instruction
{
    /// the operation to perform when executed
    hlcc::Opcode d_opcode;

    /// arguments to the operation
    hls::Integer d_arguments[3];

      public:

    /// Create a new 'Instruction' object that performs the "No-Operation".
    Instruction();

    /// Create a new 'Instruction' object having the specified 'opcode'.
    explicit Instruction(hlcc::Opcode opcode);

    /// Create a new 'Instruction' object having the specified 'opcode', and
    /// 'argument0'.
    Instruction(hlcc::Opcode opcode, hls::Integer argument0);

    /// Create a new 'Instruction' object having the specified 'opcode',
    /// 'argument0', and 'argument1'.
    Instruction(
            hlcc::Opcode opcode,
            hls::Integer argument0,
            hls::Integer argument1);

    /// Create a new 'Instruction' object having the specified 'opcode',
    /// 'argument0', 'argument1', and 'argument2'.
    Instruction(
            hlcc::Opcode opcode,
            hls::Integer argument0,
            hls::Integer argument1,
            hls::Integer argument2);

    /// Create a new 'Instruction' object having a copy of the value of the
    /// specified 'original' instruction.
    Instruction(const Instruction& original) = default;

    /// Create a new 'Instruction' object taking ownership of the value of
    /// the specified 'original' instruction.
    Instruction(Instruction&& original) = default;

    /// Destroy this object.
    ~Instruction() = default;

    /// Assign to this object the value of the specified 'original'
    /// instruction.
    Instruction& operator=(const Instruction& original) = default;

    /// Assign to this object the value of the specified 'original'
    /// instruction.
    Instruction& operator=(Instruction&& original) = default;

    /// Assign the specified 'opcode' to the operation code of this
    /// instruction.
    void setOpcode(hlcc::Opcode opcode);

    /// Assign the specified 'argument' to the first argument of this
    /// instruction.
    void setArgument0(hls::Integer argument);

    /// Assign the specified 'argument' to the second argument of this
    /// instruction.
    void setArgument1(hls::Integer argument);

    /// Assign the specified 'argument' to the third argument of this
    /// instruction.
    void setArgument2(hls::Integer argument);

    /// Return the operation code of this instruction.
    hlcc::Opcode opcode() const;

    /// Return the value of the first argument to this instruction, or 0 if
    /// no such argument has been assigned.
    hls::Integer argument0() const;

    /// Return the value of the second argument to this instruction, or 0 if
    /// no such argument has been assigned.
    hls::Integer argument1() const;

    /// Return the value of the third argument to this instruction, or 0 if
    /// no such argument has been assigned.
    hls::Integer argument2() const;
};

/// Return 'true' if the value of the specified 'lhs' is equal to the value of
/// the specified 'rhs', otherwise return 'false'.
hls::Boolean operator==(const Instruction& lhs, const Instruction& rhs);

/// Return 'true' if the value of the sepcified 'lhs' is not equal to the value
/// of the specified 'rhs', otherwise return 'false'.
hls::Boolean operator!=(const Instruction& lhs, const Instruction& rhs);

inline Instruction::Instruction()
    : d_opcode(Opcode::e_NO_OPERATION), d_arguments{}
{
}

inline Instruction::Instruction(hlcc::Opcode opcode)
    : d_opcode(opcode), d_arguments{}
{
}

inline Instruction::Instruction(hlcc::Opcode opcode, hls::Integer argument0)
    : d_opcode(opcode), d_arguments{argument0, 0, 0}
{
}

inline Instruction::Instruction(
        hlcc::Opcode opcode,
        hls::Integer argument0,
        hls::Integer argument1)
    : d_opcode(opcode), d_arguments{argument0, argument1, 0}
{
}

inline Instruction::Instruction(
        hlcc::Opcode opcode,
        hls::Integer argument0,
        hls::Integer argument1,
        hls::Integer argument2)
    : d_opcode(opcode), d_arguments{argument0, argument1, argument2}
{
}

inline void
Instruction::setOpcode(hlcc::Opcode opcode)
{
    d_opcode = opcode;
}

inline void
Instruction::setArgument0(hls::Integer argument)
{
    d_arguments[0] = argument;
}

inline void
Instruction::setArgument1(hls::Integer argument)
{
    d_arguments[1] = argument;
}

inline void
Instruction::setArgument2(hls::Integer argument)
{
    d_arguments[2] = argument;
}

inline hlcc::Opocde
Instruction::opcode() const
{
    return d_opcode;
}

inline hls::Integer
Instruction::argument0() const
{
    return d_arguments[0];
}

inline hls::Integer
Instruction::argument1() const
{
    return d_arguments[1];
}

inline hls::Integer
Instruction::argument2() const
{
    return d_arguments[2];
}

inline hls::Boolean
operator==(const Instruction& lhs, const Instruction& rhs)
{
    return lhs.d_opcode == rhs.d_opcode &&
           lhs.d_arguments[0] == rhs.d_arguments[0] &&
           lhs.d_arguments[1] == rhs.d_arguments[1] &&
           lhs.d_arguments[2] == rhs.d_arguments[2];
}

inline hls::Boolean
operator!=(const Instruction& lhs, const Instruction& rhs)
{
    return !(lhs == rhs);
}
}
}
