// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable@5.0.1/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable@5.0.1/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@5.0.1/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@5.0.1/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable@5.0.1/proxy/utils/UUPSUpgradeable.sol";

contract FiredGuys is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 private _nextTokenId;

     using Counters for Counters.Counter;

     Counters.Counter private _tokenIdCounter;

     mapping(string => uint8) existignURIs;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __ERC721_init("FiredGuys", "FYR");
        __ERC721URIStorage_init();
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function payToMint(address recipient, strin memory) {}

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    //check whether content belongs to another person
    function isContentOwned(string memory uri)public view returns(bool) {
        return existignURIs[uri] == 1; // returns true
    }

        function payToMint(address recipient, strin memory) public payable returns(uint256){
            require(existignURIs[metadataURI] != 1, "NFT has already been minted");
            require(msg.value >= 0.5 ether, "Need to pay up!");

            uint256 newItemId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            existignURIs[metadataURI] = 1;

            _mint(recipient, newItemId);
            _setTokenURI(newItemId, metadataURI);

        }
}
