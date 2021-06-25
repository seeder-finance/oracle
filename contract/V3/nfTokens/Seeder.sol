// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../../V1/utils/TrustCaller.sol";
import "../utils/SafeMathV3.sol";
import "./SeederBaseData.sol";


contract Seeder is ERC721Enumerable, SeederBaseData, TrustCaller {
    using SafeMathV3 for uint256;
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256[] private _seederCatalog;                 // Product Id list
    mapping(uint256 => string) public seederPaths;  // Seeder Id => Token URI
    
    mapping(uint256 => uint256) public tokenSeederMapping; // Token Id => Seeder Id
    
    Counters.Counter private tokenCounter;

    constructor() ERC721("Seeder", "SEEDER") {}

    function mint(address to, uint256 seederId) external onlyTrustCaller {
        require(to != address(0), "Seeder: Zero address cannot own Seeder");
        require(bytes(seederPaths[seederId]).length != 0, "Seeder: Seeder does not exist");

        tokenCounter.increment();
        uint256 tokenId = tokenCounter.current();

        _safeMint(to, tokenId);

        tokenSeederMapping[tokenId] = seederId;
    }

    function burn(uint256 tokenId) external {
        require(_exists(tokenId), "Seeder: Token does not exist");

        _burn(tokenId);

        delete tokenSeederMapping[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory uri) {
        require(_exists(tokenId), "Seeder: Token does not exist");

        uint256 seederId = tokenSeederMapping[tokenId];
        string memory seederPath = seederPaths[seederId];

        string memory baseURI = _baseURI();
        string memory seederURI = string(abi.encodePacked(baseURI, seederPath));
        uri = string(abi.encodePacked(seederURI, tokenId.toString()));
    }

    function seederCatalog() external view returns (uint256[] memory catalog) {
        catalog = _seederCatalog;
    }

    // ================== Owner method ===================

    function addSeeder(uint256 seederId, string memory path) external onlyOwner {
        require(bytes(seederPaths[seederId]).length == 0, "Seeder: Seeder already does exist");
        require(bytes(path).length > 0, "Seeder: Path need to be clarified");

        _seederCatalog.push(seederId);
        seederPaths[seederId] = path;
    }

    function changeSeeder(uint256 seederId, string memory path) external onlyOwner {
        require(bytes(seederPaths[seederId]).length != 0, "Seeder: Seeder does not exist");
        require(bytes(path).length > 0, "Seeder: Path need to be clarified");

        seederPaths[seederId] = path;
    }

    // ================== Override method ===============
} 