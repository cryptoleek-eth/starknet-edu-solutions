// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IStarknetCore.sol";
import "./ISolution.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PlayerConsumer is Ownable {
    IStarknetCore starknetCore;
    uint256 private EvaluatorContractAddress;

    constructor(address starknetCore_) {
        starknetCore = IStarknetCore(starknetCore_);
    }

    function setEvaluatorContractAddress(uint256 _evaluatorContractAddress)
        external
        onlyOwner
    {
        EvaluatorContractAddress = _evaluatorContractAddress;
    }

    function consumeMessage(uint256 l2ContractAddress, uint256 l2User) external {
        uint256[] memory sender_payload = new uint256[](1);
        sender_payload[0] = l2User;
        // Consume the message from L2.
        starknetCore.consumeMessageFromL2(l2ContractAddress, sender_payload);
    }
}
