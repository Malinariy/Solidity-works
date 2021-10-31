pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface game_interface {
    function get_attack(uint damage) external;
}
