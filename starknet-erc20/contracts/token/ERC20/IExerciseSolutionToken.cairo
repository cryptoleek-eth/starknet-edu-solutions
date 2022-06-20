%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IExerciseSolutionToken:
    func mint(depositor: felt, amount: Uint256) -> (success: felt):
    end

    func burn(burn_addr: felt, amount: Uint256) -> (success: felt):
    end
end
