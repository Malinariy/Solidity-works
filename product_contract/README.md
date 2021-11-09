## Simple product contract

This contract contains the main function that multiplies by the initialized value.

The value to be multiplied must meet certain conditions: it must be greater than zero and less than ten.
.
```solidity
	function product(uint value) public checkOwnerAndAccept {

        require(value > 0 && value <= 10, 101, format( "The value {} out of range from 1 to 10", value));
        
		sum *= value;
	}
```
