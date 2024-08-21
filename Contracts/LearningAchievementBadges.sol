// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearningAchievementBadges {

    // Structure for a Badge
    struct Badge {
        string name;
        string description;
        bool exists;
    }

    // Mapping from badge ID to Badge details
    mapping(uint256 => Badge) public badges;

    // Mapping from user address to badge IDs
    mapping(address => uint256[]) public userBadges;

    // Event to log the awarding of a badge
    event BadgeAwarded(address indexed user, uint256 badgeId);

    // Address of the contract owner
    address public owner;

    // Modifier to restrict access to certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to create a new badge (only accessible by the owner)
    function createBadge(uint256 badgeId, string memory name, string memory description) public onlyOwner {
        require(!badges[badgeId].exists, "Badge already exists with this ID");

        badges[badgeId] = Badge({
            name: name,
            description: description,
            exists: true
        });
    }

    // Function to award a badge to a user
    function awardBadge(address user, uint256 badgeId) public onlyOwner {
        require(badges[badgeId].exists, "Badge does not exist");

        userBadges[user].push(badgeId);

        emit BadgeAwarded(user, badgeId);
    }

    // Function to view all badges of a user
    function getUserBadges(address user) public view returns (uint256[] memory) {
        return userBadges[user];
    }

    // Function to view badge details by ID
    function getBadgeDetails(uint256 badgeId) public view returns (string memory name, string memory description) {
        require(badges[badgeId].exists, "Badge does not exist");

        Badge memory badge = badges[badgeId];
        return (badge.name, badge.description);
    }
}
