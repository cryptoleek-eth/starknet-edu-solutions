%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address

from contracts.token.ERC20.IDTKERC20 import IDTKERC20

from contracts.token.ERC20.IExerciseSolutionToken import IExerciseSolutionToken

from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_mul,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
    uint256_neg,
)

@storage_var
func token_balances_storage(account : felt) -> (balance : Uint256):
end

@storage_var
func token_address_storage() -> (address : felt):
end

@storage_var
func exercise_solution_token_stroage() -> (address : felt):
end

@constructor
func constructor{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        token_address: felt,
        exercise_solution_token_addr: felt,
    ):
    token_address_storage.write(token_address)
    exercise_solution_token_stroage.write(exercise_solution_token_addr)
    return ()
end

@external
func deposit_tokens{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount : Uint256) -> (total_amount : Uint256):
    return deposit_tokens_ex16_17(amount)
end

func deposit_tokens_ex15{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount : Uint256) -> (total_amount : Uint256):
    alloc_locals

    let (caller) = get_caller_address()
    let (self_address) = get_contract_address()

    let (token_addr) = token_address_storage.read()
    let (isSuccess) = IDTKERC20.transferFrom(contract_address=token_addr, sender=caller, recipient=self_address, amount=amount)

    if isSuccess == 1:
         let (old_amount : Uint256) = token_balances_storage.read(caller)

        let (new_balance: Uint256, is_overflow) = uint256_add(old_amount, amount)
        assert is_overflow = 0

        token_balances_storage.write(caller, new_balance)
        return (amount)
    else:
        return (Uint256(0,0))
    end
end


func deposit_tokens_ex16_17{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount : Uint256) -> (total_amount : Uint256):
    alloc_locals

    let (caller) = get_caller_address()
    let (self_address) = get_contract_address()

    let (token_addr) = token_address_storage.read()
    let (isSuccess) = IDTKERC20.transferFrom(contract_address=token_addr, sender=caller, recipient=self_address, amount=amount)

    if isSuccess == 1:
        let (old_amount : Uint256) = token_balances_storage.read(caller)
        let (new_balance: Uint256, is_overflow) = uint256_add(old_amount, amount)
        assert is_overflow = 0
        token_balances_storage.write(caller, new_balance)

        let (solution_token_addr) = deposit_tracker_token()
        IExerciseSolutionToken.mint(contract_address = solution_token_addr, depositor=caller, amount=amount)

        return (new_balance)
    else:
        return (Uint256(0,0))
    end
end

@view
func tokens_in_custody{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account : felt) -> (amount : Uint256):
    let (balance : Uint256) = token_balances_storage.read(account)

    return (amount = balance)
end

@external
func get_tokens_from_contract{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (amount : Uint256):
    alloc_locals

    let (caller) = get_caller_address()
    let (token_addr) = token_address_storage.read()
    let (isSuccess) = IDTKERC20.faucet(contract_address=token_addr)

    if isSuccess == 1:
        let new_amount: Uint256 = Uint256(100*1000000000000000000, 0)
        let (old_amount : Uint256) = token_balances_storage.read(caller)

        let (new_balance: Uint256, is_overflow) = uint256_add(old_amount, new_amount)
        assert is_overflow = 0

        token_balances_storage.write(caller, new_balance)

        return (amount = new_amount)
    end

    return (Uint256(0, 0))
end

@external
func withdraw_all_tokens{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (amount : Uint256):
    alloc_locals

    let (caller) = get_caller_address()
    let (self) = get_contract_address()

    let (token_addr) = token_address_storage.read()
    let (balance : Uint256) = token_balances_storage.read(caller)

    let (has_balance) = uint256_lt(Uint256(0,0), balance)

    if has_balance == 1:
        token_balances_storage.write(caller, Uint256(0,0))
        IDTKERC20.transfer(contract_address=token_addr, recipient=caller, amount=balance)

        let (tracker_token_addr) = deposit_tracker_token()
        IExerciseSolutionToken.burn(contract_address=tracker_token_addr, burn_addr=caller, amount=balance)

        return (balance)
    end

    return (Uint256(0, 0))
end

@view
func deposit_tracker_token{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (deposit_tracker_token_address : felt):
    let ( deposit_tracker_token_address ) = exercise_solution_token_stroage.read()

    return (deposit_tracker_token_address)
end

@external
func set_deposit_tracker_token{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(address: felt) -> ():
    exercise_solution_token_stroage.write(address)
    return ()
end