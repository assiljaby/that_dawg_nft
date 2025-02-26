// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "script/BasicNft.s.sol";

contract CounterTest is Test {
    BasicNft private basicNft;
    address private immutable i_user = makeAddr("USER");
    string private constant TOKEN_URI = "https://bafybeihvrr2zo2stmgtlavkwbsxjoxwrp3w2j54mv4lqxrjncj73rppns4.ipfs.dweb.link?filename=dawg.json";

    function setUp() public {
        DeployBasicNft deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
    }

    function testInitialState() public view {
        assertEq(basicNft.getTokenCounter(), 0);
    }

    function testNameIscorrect() public view {
        /**
         * The reason why we encoded then hashed the strings is
         * because strings are arrays. In solidity arrays are not
         * comparable.
         * 
         * `abi.encodePacked` returns bytes
         * keccak256 hashes the bytes into a fixed length bytes32
         * which is a comparable type
         */
        bytes32 expectedName = keccak256(abi.encodePacked("That Dawg"));
        bytes32 actualName = keccak256(abi.encodePacked(basicNft.name()));

        assert(expectedName == actualName);
    }

    function testSymbolIscorrect() public view {
        bytes32 expectedName = keccak256(abi.encodePacked("DAWG"));
        bytes32 actualName = keccak256(abi.encodePacked(basicNft.symbol()));

        assert(expectedName == actualName);
    }

    function testUserCanMintAndHaveABalance() public {
        uint256 initCounter = basicNft.getTokenCounter();

        vm.prank(i_user);
        basicNft.mintNft(TOKEN_URI);

        string memory currentURI = basicNft.tokenURI(initCounter);
        assertEq(basicNft.getTokenCounter(), initCounter + 1);
        assertEq(
            keccak256(abi.encodePacked(currentURI)),
            keccak256(abi.encodePacked(TOKEN_URI))
        );
        assertEq(basicNft.balanceOf(i_user), 1);
    }
}
