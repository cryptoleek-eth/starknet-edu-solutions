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
func l1_contract_address_stroage() -> (l1_contract_address_stroage : felt):
end

@view
func l1_contract_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (l1_contract_address : felt):
    let (l1_contract_address) = l1_contract_address_stroage.read()
    return (l1_contract_address)
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    l1_contract_address : felt
):
    l1_contract_address_stroage.write(l1_contract_address)
    return ()
end

@external
func create_l1_nft_message{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(l1_user: felt):
    alloc_locals
    # Reading caller address
    let (sender_address) = get_caller_address()

    # Sending the Mint message.
    let (message_payload : felt*) = alloc()
    assert message_payload[0] = l1_user

    let (l1_contract_address) = l1_contract_address_stroage.read()
    send_message_to_l1(to_address=l1_contract_address, payload_size=1, payload=message_payload)
    return ()
end