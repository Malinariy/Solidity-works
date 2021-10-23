pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract create_token {

    struct Token { 
        string  name; 
        uint  weight; 
        string  color;
        int price;
    }

    Token[] tokenArr;

    mapping (uint256=>uint256) tokenToOwner;
    mapping (string=>bool) isTaken; // name verification
    mapping (uint256=>bool) saleTrans; 


    modifier duplicated_name(string new_token_name) {
        require(!isTaken[new_token_name], 102, 'This name is already registered');
        isTaken[new_token_name] = true;
        _;
    }

    modifier check_for_sale(uint tokenId) {
        require(msg.pubkey() == tokenToOwner[tokenId], 101, 'The rights to this token are held by another person');
        require(!saleTrans[tokenId], 102, 'This token is already up for sale');
        saleTrans[tokenId] = true;
        _;
    }


    function token_create(string name, uint weight, string color)public duplicated_name(name){
        tvm.accept();
        tokenArr.push(Token({name:name, weight:weight, color:color, price:0}));

        uint256 keyAsLastNum = tokenArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    function set_token_price(uint tokenId, int token_price) public check_for_sale(tokenId){
        tvm.accept();
        tokenArr[tokenId].price = token_price;
    }



    function change_owner(uint tokenId, uint pubKeyOfNewOwner) public {
        require(msg.pubkey() == tokenToOwner[tokenId], 101);
        tvm.accept();
        tokenToOwner[tokenId] = pubKeyOfNewOwner;
    }

    function get_token_Owner(uint tokenId) public view returns (uint) {
        return tokenToOwner[tokenId];
    }

    function get_token_price(uint tokenId) public view returns (int){
        return tokenArr[tokenId].price;   
    }
}
