%lang starknet
%builtins pedersen range_check ecdsa

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.uint256 import Uint256

from contracts.token.ERC721.ERC721_base import (
    ERC721_name, ERC721_symbol, ERC721_balanceOf, ERC721_ownerOf, ERC721_getApproved,
    ERC721_isApprovedForAll, ERC721_mint, ERC721_burn, ERC721_initializer, ERC721_approve,
    ERC721_setApprovalForAll, ERC721_transferFrom, ERC721_safeTransferFrom)

from contracts.IEvaluator import IEvaluator

#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        name : felt, symbol : felt):
    ERC721_initializer(name, symbol)
    return ()
end

#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#

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
func evaluator_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    evaluator_address : felt
):
    let (evaluator_address) = evaluator_address_storage.read()
    return (evaluator_address)
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

@view
func get_animal_characteristics{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (sex : felt, legs : felt, wings : felt):
    let (sex) = sex_storage.read(token_id)
    let (legs) = legs_storage.read(token_id)
    let (wings) = wings_storage.read(token_id)

    return (sex, legs, wings)
end

@external
func mint_animal_with_characteristics{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to_ : felt) -> ():
    let to = to_
    let token_id : Uint256 = Uint256(1, 0)
    ERC721_mint(to, token_id)

    let (sender_address) = get_caller_address()
    let (evaluator_address) = evaluator_address_storage.read()
    let (sex) = IEvaluator.assigned_sex_number(contract_address=evaluator_address, player_address=sender_address)
    let (legs) = IEvaluator.assigned_legs_number(contract_address=evaluator_address, player_address=sender_address)
    let (wings) = IEvaluator.assigned_wings_number(contract_address=evaluator_address, player_address=sender_address)

    sex_storage.write(token_id, sex)
    legs_storage.write(token_id, legs)
    wings_storage.write(token_id, wings)

    return ()
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



##
# # Temporary functions, will remove once account contracts are live and usable with Nile
##
##
@storage_var
func setup_is_finished() -> (setup_is_finished : felt):
end

@external
func set_evaluator_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    evaluator_address : felt
):
    let (permission) = setup_is_finished.read()
    assert permission = 0
    evaluator_address_storage.write(evaluator_address)
    setup_is_finished.write(1)
    return ()
end