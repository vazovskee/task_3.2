
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    int8 public undoneTasksAmount;
    int8 private lastTaskNumber;
    int8 private constant INT8_MAX = 127;

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

    modifier checkTaskExistence(int8 taskNumber) {
        require(tasks.exists(taskNumber), 201, "task with this number dosn't exist");
        _;
    }

    function addTask(string title) public checkOwnerAndAccept {
        require(lastTaskNumber < INT8_MAX, 202, "maximum number of tasks has been reached");

        lastTaskNumber++;
        tasks[lastTaskNumber] = Task(title, now, false);
        undoneTasksAmount++;
    }

    function removeTask(int8 taskNumber)
        public
        checkOwnerAndAccept
        checkTaskExistence(taskNumber)
    {
        if (!tasks[taskNumber].isDone) {
            undoneTasksAmount--;
        }
        delete tasks[taskNumber];
    }

    function setTaskAsDone(int8 taskNumber)
        public
        checkOwnerAndAccept
        checkTaskExistence(taskNumber)
    {
        require(!tasks[taskNumber].isDone, 203, "this task has already been done");
        
        undoneTasksAmount--;
        tasks[taskNumber].isDone = true;
    }

    function getTaskByNum(int8 taskNumber)
        public view
        checkTaskExistence(taskNumber)
        returns (Task)
    {   
        return tasks[taskNumber];
    }
}
