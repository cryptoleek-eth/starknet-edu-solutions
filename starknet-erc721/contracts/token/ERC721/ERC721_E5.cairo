%lang starknet
%builtins pedersen range_check ecdsa

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub, uint256_le, uint256_lt, uint256_check, uint256_eq
)

from contracts.token.ERC721.ERC721_base import (
    ERC721_name, ERC721_symbol, ERC721_balanceOf, ERC721_ownerOf, ERC721_getApproved,
    ERC721_isApprovedForAll, ERC721_mint, ERC721_burn, ERC721_initializer, ERC721_approve,
    ERC721_setApprovalForAll, ERC721_transferFrom, ERC721_safeTransferFrom)

from contracts.utils.Ownable_base import (
    Ownable_initializer,
    Ownable_only_owner,
    Ownable_get_owner,
    Ownable_transfer_ownership
)

from contracts.token.ERC20.IERC20 import IERC20

#
# Constructor
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        name : felt, symbol : felt, evaluator_addr : felt, dummy_token_address : felt):
    ERC721_initializer(name, symbol)
    let one_as_uint = Uint256(1,0)
    next_token_id_storage.write(one_as_uint)
    evaluator_address_storage.write(evaluator_addr)
    dummy_token_address_storage.write(dummy_token_address)
    return ()
end

#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#
@storage_var
func dummy_token_address_storage() -> (dummy_token_address: felt):
end

@storage_var
func registered_breeders(breeder: felt) -> (is_breeder: felt):
end

@storage_var
func ERC721_Enumerable_owned_tokens(owner: felt, index: Uint256) -> (token_id: Uint256):
end

@storage_var
func ERC721_Enumerable_owned_tokens_index(token_id: Uint256) -> (index: Uint256):
end

@storage_var
func next_token_id_storage() -> (next_token_id: Uint256):
end

@storage_var
func sex_storage(token_id: Uint256) -> (sex_storage : felt):
end

@storage_var
func legs_storage(token_id: Uint256) -> (legs_storage : felt):
end

@storage_var
func wings_storage(token_id: Uint256) -> (wings_storage : felt):
end

@storage_var
func evaluator_address_storage() -> (evaluator_address_storage : felt):
end

#
# Getters
#

@view
func dummy_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    dummy_token_address : felt
):
    let (dummy_token_address) = dummy_token_address_storage.read()
    return (dummy_token_address)
end

@view
func evaluator_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    evaluator_address : felt
):
    let (evaluator_address) = evaluator_address_storage.read()
    return (evaluator_address)
end

@view
func next_token_id{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (next_token_id: Uint256):
    let (next_token_id) = next_token_id_storage.read()
    return (next_token_id=next_token_id)
end

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (name) = ERC721_name()
    return (name)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (symbol) = ERC721_symbol()
    return (symbol)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
        balance : Uint256):
    let (balance : Uint256) = ERC721_balanceOf(owner)
    return (balance)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (owner : felt):
    let (owner : felt) = ERC721_ownerOf(token_id)
    return (owner)
end

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (approved : felt):
    let (approved : felt) = ERC721_getApproved(token_id)
    return (approved)
end

@view
func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, operator : felt) -> (is_approved : felt):
    let (is_approved : felt) = ERC721_isApprovedForAll(owner, operator)
    return (is_approved)
end

#
# Externals
#

@external
func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        to : felt, token_id : Uint256):
    ERC721_approve(to, token_id)
    return ()
end

@external
func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        operator : felt, approved : felt):
    ERC721_setApprovalForAll(operator, approved)
    return ()
end

@external
func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256):
    ERC721_transferFrom(_from, to, token_id)
    return ()
end

@external
func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256, data_len : felt, data : felt*):
    ERC721_safeTransferFrom(_from, to, token_id, data_len, data)
    return ()
end

@external
func declare_animal{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(sex : felt, legs : felt, wings : felt) -> (token_id : Uint256):
    alloc_locals
    let (token_id) = next_token_id_storage.read()

    sex_storage.write(token_id, sex)
    legs_storage.write(token_id, legs)
    wings_storage.write(token_id, wings)

    let one_as_uint = Uint256(1,0)
    let (next_token_id, _) = uint256_add(one_as_uint, token_id)
    next_token_id_storage.write(next_token_id)

    let (evaluator_address) = evaluator_address_storage.read()
    _add_token_to_owner_enumeration(evaluator_address, token_id)
    ERC721_mint(evaluator_address, token_id)

    return (token_id=token_id)
end

@external
func declare_dead_animal{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(token_id: Uint256):
    # let (from_) = ERC721.owner_of(token_id)
    # _remove_token_from_owner_enumeration(from_, token_id)
    # _remove_token_from_all_tokens_enumeration(token_id)
    sex_storage.write(token_id, 0)
    legs_storage.write(token_id, 0)
    wings_storage.write(token_id, 0)

    ERC721_burn(token_id)
    return ()
end

func _add_token_to_owner_enumeration{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(to: felt, token_id: Uint256):
    let (length: Uint256) = ERC721_balanceOf(to)
    ERC721_Enumerable_owned_tokens.write(to, length, token_id)
    ERC721_Enumerable_owned_tokens_index.write(token_id, length)
    return ()
end

@view
func get_animal_characteristics{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (sex : felt, legs : felt, wings : felt):
    let (sex) = sex_storage.read(token_id)
    let (legs) = legs_storage.read(token_id)
    let (wings) = wings_storage.read(token_id)

    return (sex, legs, wings)
end

@view
func token_of_owner_by_index{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(account: felt, index: felt) -> (token_id: Uint256):
    alloc_locals
    let uint256_index = Uint256(index,0)
    let (token_id: Uint256) = ERC721_Enumerable_owned_tokens.read(account, uint256_index)
    return (token_id)
end

@view
func is_breeder{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(account : felt) -> (is_approved : felt):
    let(is_approved) = registered_breeders.read(account)
    return (is_approved)
end

@view
func registration_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (price : Uint256):
    let price: Uint256 = Uint256(1*1000000000000000000, 0) # hardcoded for now
    return (price)
end

@external
func register_me_as_breeder{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (is_added : felt):
    let (dummy_token_address) = dummy_token_address_storage.read()

    let (caller_addr) = get_caller_address()
    let (self) = get_contract_address()
    let (fee) = registration_price()
    let (success) = IERC20.transferFrom(contract_address=dummy_token_address, sender=caller_addr, recipient=self, amount=fee)
    registered_breeders.write(caller_addr, success)
    return (success)
end