pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Accumulator {

	// State variable storing the sum of arguments that were passed to function 'add',
	uint public sum = 1; // initializing by 1

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	// Function that adds its argument to the state variable.
	function product(uint value) public checkOwnerAndAccept {

        require(value > 0 && value <= 10, 101, format( "The value {} out of range from 1 to 10", value));
        
		sum *= value;
	}
}