%lang starknet

####################
# INTERFACE
####################

@contract_interface
namespace IEvaluator:
    func assigned_rank(player_address: felt) -> (rank: felt):
    end
    func assigned_legs_number(player_address: felt) -> (legs: felt):
    end
    func assigned_sex_number(player_address: felt) -> (sex: felt):
    end
    func assigned_wings_number(player_address: felt) -> (wings: felt):
    end
end