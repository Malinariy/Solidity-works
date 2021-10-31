pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'game_object.sol';
import 'military_unit.sol' as mil_unit;

contract base_station is game_object{

    address[] public units;

    constructor(uint def_base_val) public {
        get_def_value(def_base_val);
    }

    function create_unit() public { 
        tvm.accept();
        units.push(msg.sender);
    }

    function delete_unit() public { 
        tvm.accept();
        for (uint i = 0; i < units.length; i++){
            if (units[i] == msg.sender){
                delete units[i];
            }
        } 
    }

    function get_def_value(uint def_base_value) public override{
        tvm.accept();
        def_value += def_base_value;
    }

    function death_ceremony(address murderer) internal override{
        for (uint id = 0; id < units.length; id++){
            mil_unit.military_unit(units[id]).death_by_base_station(murderer);
        }
        self_destruction(murderer);
    }

    function show_units() public view returns (address[]) {
        tvm.accept();
        return units;
    }
}