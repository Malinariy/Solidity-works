pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'game_object.sol';
import 'base_station.sol'; 

contract military_unit is game_object {

    uint  atk_value;
    address public address_base;

    constructor(base_station base) public {
        require(msg.pubkey() == tvm.pubkey(), 101, 'Constructor error');
		tvm.accept();
        base.create_unit();
        address_base = address(base);
    }

    function get_attack_value(uint value) virtual public checkOwnerAndAccept{
        atk_value = value;
    }

    function attack(game_interface gameObjectInterface) public checkOwnerAndAccept{
        gameObjectInterface.get_attack(atk_value);
    }

    function death_ceremony(address murderer) internal override{
        base_station(address_base).delete_unit(this);
        self_destruction(murderer);
    }

    function death_by_base_station(address murderer) public {
        tvm.accept();
        require(msg.sender == address_base, 102, "You are not the owner!");
        death_ceremony(murderer);
    }
}
