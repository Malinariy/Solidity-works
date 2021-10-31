pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'military_unit.sol';

contract warrior is military_unit {

   constructor(base_station base, uint atk, uint def) military_unit(base) public {
      get_attack_value(atk);
      get_def_value(def);
   }

   function get_attack_value(uint value) public override checkOwnerAndAccept{
      atk_value += value;
   }
   function get_def_value(uint value) public override checkOwnerAndAccept{
      def_value += value;
   }
}