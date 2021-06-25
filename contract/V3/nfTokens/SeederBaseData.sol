// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SeederBaseData is Ownable {
    mapping(bytes32 => SeederBaseState) public seederNameToBaseStates;
    bytes32[] public listOfSeederNames;
    
    struct SeederBaseState {
        bytes32 name;
        bool isMale;
        uint256 strength;
        uint256 smart;
        uint256 speed;
        uint256 luck;
        
        // Add element
    }

    constructor() {}

    function createSeederBaseStat(bytes32 name, bool isMale, uint256 strength, uint256 smart, uint256 speed, uint256 luck) public onlyOwner {
        require(seederNameToBaseStates[name].strength == 0, "SeederBaseData: Create duplicate seeder");

        seederNameToBaseStates[name] = SeederBaseState({
            name: name,
            isMale: isMale,
            strength: strength,
            smart: smart,
            speed: speed,
            luck: luck
        });
    }
}