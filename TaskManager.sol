
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    struct Task {
        string title;
        uint32 creationTime;
        bool isDone; 
    }

    mapping(int8 => Task) tasks;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
}
