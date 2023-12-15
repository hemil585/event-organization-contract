// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract EventOrganization {
    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    function createEvent(
        string memory name,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    ) public {
        require(
            date > block.timestamp,
            "Event can only be organize for future date"
        );
        require(
            ticketCount > 0,
            "You can organize event if you create more than 0 tickets"
        );

        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        );
        nextId++;
    }

    function buyTickets(uint256 id, uint256 quantity) external payable {
        require(events[id].date != 0, "Event does not exist");
        require(
            events[id].date > block.timestamp,
            "Event has already occured, you're late!"
        );
        Event storage _event = events[id];
        require(
            msg.value == (_event.price * quantity),
            "Ethers are not enough"
        );
        require(_event.ticketRemain >= quantity, "Not enough tickets");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTickets(
        uint256 id,
        uint256 quantity,
        address to
    ) external payable {
        require(events[id].date != 0, "Event does not exist");
        require(
            events[id].date > block.timestamp,
            "Event has already occured, you're late!"
        );
        require(
            tickets[msg.sender][id] >= quantity,
            "Not enough number of tickets"
        );
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
