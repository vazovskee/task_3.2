
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    int8 public undoneTasksAmount;
    int8 private lastTaskNumber;

    struct Task {
        string title;
        uint32 creationTime;
        bool isDone; 
    }

    mapping(int8 => Task) public tasks;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function addTask(string title) public checkOwnerAndAccept {
        lastTaskNumber++;
        tasks[lastTaskNumber] = Task(title, now, false);
        undoneTasksAmount++;
	}

    function removeTask(int8 taskNumber) public checkOwnerAndAccept {
        require(tasks.exists(taskNumber), 201, "task with this number dosn't exist");
        if (!tasks[taskNumber].isDone) {
            undoneTasksAmount--;
        }
        delete tasks[taskNumber];
	}

    function setTaskAsDone(int8 taskNumber) public checkOwnerAndAccept {
        require(tasks.exists(taskNumber), 201, "task with this number dosn't exist");
        if (!tasks[taskNumber].isDone) {
            undoneTasksAmount--;
        }
        tasks[taskNumber].isDone = true;
	}
}
