
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
}
