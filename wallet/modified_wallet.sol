pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    /// @dev Allows to transfer tons to the destination account.
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    /// @param bounce Flag that enables bounce message in case of target contract error.
    function sendTransaction(address dest, uint128 value, bool bounce) public pure access {
         // Runtime function that allows to make a transfer with arbitrary settings.
        dest.transfer(value, bounce, 0);
    }

    function send_without_fee(address addr, uint128 amount) public access{
        addr.transfer(amount, false, 0);
    }

    function send_with_fee(address addr, uint128 amount) public access{
        addr.transfer(amount, false, 1);
    }

    function send_and_destroy(address addr, uint128 amount) public access{
        addr.transfer(amount, false, 160);
    }

    modifier access {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        _;
    }
}
