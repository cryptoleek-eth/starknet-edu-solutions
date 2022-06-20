# ######## Messaging bridge evaluator

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.messages import send_message_to_l1

@storage_var
func rand_var_storage() -> (rand_var_storage : felt):
end

@view
func rand_var{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (rand_var : felt):
    let (rand_var) = rand_var_storage.read()
    return (rand_var)
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return ()
end

@view
func l1_assigned_var{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (assigned_var: felt):
    let (assigned_var) = rand_var_storage.read()
    return (assigned_var)
end

@l1_handler
func assign_var_from_l1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(from_address : felt, rand_value : felt):
    rand_var_storage.write(rand_value)
    return ()
end