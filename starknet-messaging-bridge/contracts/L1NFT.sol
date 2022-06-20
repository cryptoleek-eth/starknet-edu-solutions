// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./L1/interfaces/IStarknetCore.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract L1NFT is Ownable {
    IStarknetCore starknetCore;
    uint256 private CLAIM_SELECTOR;
    uint256 private EvaluatorContractAddress;

    constructor(address starknetCore_) {
        starknetCore = IStarknetCore(starknetCore_);
    }

    function setClaimSelector(uint256 _claimSelector) external onlyOwner {
        CLAIM_SELECTOR = _claimSelector;
    }

    function setEvaluatorContractAddress(uint256 _evaluatorContractAddress)
        external
        onlyOwner
    {
        EvaluatorContractAddress = _evaluatorContractAddress;
    }

    function createNftFromL2(uint256 l2_user) public {
        uint256[] memory sender_payload = new uint256[](1);
        sender_payload[0] = l2_user;
        // Send the message to the StarkNet core contract.
        starknetCore.sendMessageToL2(
            EvaluatorContractAddress,
            CLAIM_SELECTOR,
            sender_payload
        );
    }
}
