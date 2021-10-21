pragma ton-solidity >= 0.35.0;

contract queue {

    string[] public strings;

    function pushing(string str) public {
		tvm.accept();
        strings.push(str);
    }

	function deleting() public {
		tvm.accept();
		delete strings[0];
	}
}
