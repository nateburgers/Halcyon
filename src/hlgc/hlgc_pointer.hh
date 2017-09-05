/// @file hlgc_pointer.hh
///

#pragma once

namespace Halcyon {
namespace hls {

using NullPointer = decltype(nullptr);

template <typename VALUE_TYPE>
class Pointer
{
  public:
    // TYPES
    using Value = VALUE_TYPE;

  private:
    // DATA
    Value* d_value_p;

  public:
    // CREATORS
    Pointer();

    explicit Pointer(NullPointer* null);

    explicit Pointer(Value* value);

    Pointer(const Pointer& original) = default;

    Pointer(Pointer&& original) = default;

    template <typename CONVERTED_VALUE_TYPE>
    Pointer(const Pointer<CONVERTED_VALUE_TYPE>& original);

    template <typename CONVERTED_VALUE_TYPE>
    Pointer(Pointer<CONVERTED_VALUE_TYPE>&& original);

    ~Pointer() = default;

    // MANIPULATORS
    Pointer& operator=(const Pointer& original);

    Pointer& operator=(Pointer&& original);

    template <typename CONVERTED_VALUE_TYPE>
    Pointer& operator=(const Pointer<CONVERTED_VALUE_TYPE>& original);

    template <typename CONVERTED_VALUE_TYPE>
    Pointer& operator=(Pointer<CONVERTED_VALUE_TYPE>&& original);

    // ACCESSORS
    Value& operator*() const;

    Value* operator->() const;

    Value* get() const;

    explicit operator bool() const;

};

}
}

namespace Halcyon {
namespace hlgc {

class PointerControlBlock
{
  public:
    // TYPES

    // CREATORS
    virtual ~PointerControlBlock() = 0;

    // MANIPULATORS

};

template <typename VALUE_TYPE>
class Pointer
{
  public:
    // TYPES
    using Value = VALUE_TYPE;

  private:
    // DATA
    PointerControlBlock* d_controlBlock_p;
    Value*               d_value_p;

  public:
    // CREATORS
    Pointer(PointerControlBlock* controlBlock,
            Value*               value);

    Pointer(PointerControlBlock* controlBlock,
            const Pointer&       original);

    Pointer(PointerControlBlock* controlBlock,
            Pointer&&            original);

    template <typename OTHER_VALUE_TYPE>
    Pointer(PointerControlBlock*             controlBlock,
            const Pointer<OTHER_VALUE_TYPE>& original);

    template <typename OTHER_VALUE_TYPE>
    Pointer(PointerControlBlock*        controlBlock,
            Pointer<OTHER_VALUE_TYPE>&& original);

    Pointer(const Pointer& original);

    Pointer(Pointer&& original);

    template <typename OTHER_VALUE_TYPE>
    Pointer(const Pointer<OTHER_VALUE_TYPE>& original);

    template <typename OTHER_VALUE_TYPE>
    Pointer(Pointer<OTHER_VALUE_TYPE>&& original);

    /// Destroy this object.
    ~Pointer();

    // MANIPULATORS

    /// Replace the pointer of this object with the pointer of the specified
    /// 'original'.
    Pointer& operator=(const Pointer& original);

    /// Replace the pointer of this object with the pointer of the specified
    /// 'original'.
    Pointer& operator=(Pointer&& original);

    /// Replace the pointer of this object with the pointer of the specified
    /// 'original'.
    template <typename OTHER_VALUE_TYPE>
    Pointer& operator=(const Pointer<OTHER_VALUE_TYPE>& original);

    /// Replace the pointer of this object with the pointer of the specified
    /// 'original'.
    template <typename OTHER_VALUE_TYPE>
    Pointer& operator=(Pointer<OTHER_VALUE_TYPE>&& original);

    /// Return a reference providing non-modifiable access to the control
    /// block of this object.
    PointerControlBlock& controlBlock() const;

    // ACCESSORS

    /// Return a reference providing non-modifiable access to the value this
    /// object points to.
    Value& operator*() const;

    /// Return a pointer providing modifiable access to the value this object
    /// points to.
    Value* operator->() const;

    /// Return a pointer providing modifiable access to the value this object
    /// points to.
    Value* pointer() const;

    /// Return a reference providing non-modifiable access to the control
    /// block of this object.
    const PointerControlBlock& controlBlock() const;

    /// Return 'true' if this object is not null, otherwise return 'false'.
    explicit operator bool() const;

};

struct PointerUtil
{
    // CLASS METHODS

    /// Return a new 'Pointer' object having the specified 'controlBlock'
    /// with a 'value' constructed in-place with the specified 'allocator'.
    template <typename VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    Pointer<VALUE_TYPE> make(PointerControlBlock*         controlBlock,
                             hls::Allocator*              allocator,
                             CONSTRUCTION_PARAMETERS&&... parameters);
};

}
}
