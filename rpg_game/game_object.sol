pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'igo.sol';

contract game_object is game_interface {

    uint health = 50;
    uint  def_value = 0;

    function get_attack(uint damage) external override {
        health = health - (damage - def_value);
        if (check_death() == true){
            death_ceremony(msg.sender);
        }
    }

    function check_death() private view returns (bool){
        return health <= 0;
    }

    function get_def_value(uint value)virtual public checkOwnerAndAccept{
        tvm.accept();
        def_value += value;
    }

    function death_ceremony(address murderer)virtual internal {
        self_destruction(murderer);
    }

    function self_destruction(address murderer)virtual internal {
        murderer.transfer(0, true, 160);
    }

    modifier checkOwnerAndAccept() {
        require(msg.pubkey() == tvm.pubkey(), 102, 'You are not the owner!');
        tvm.accept();
        _;
    }

}
