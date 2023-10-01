// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

contract RoleManager {
    bytes32 private constant ADMIN = keccak256(bytes("ADMIN"));

    event RoleGranted(
        address to,
        bytes32 role
    );
    event RoleRevoked(
        address to,
        bytes32 role
    );
    event RoleAdded(
        string role
    );

    string[] private roles;
    mapping (bytes32 => bool) private isActive;
    mapping (bytes32 => mapping (address => bool)) private role;

    modifier onlyRole(bytes32 _role) {
        require(
            isActive[_role] == true,
            "Role not found"
        );
        require(
            role[_role][msg.sender] == true,
            "You have not the desired role"
        );
        _;
    }

    constructor(
        address[] memory _admins
    ) {
        for (uint i; i < _admins.length; ++i) {
            address admin = _admins[i];

            require(
                role[ADMIN][admin] == false,
                "Duplicated admin addresses"
            );

            role[ADMIN][admin] = true;
        }
    }

    function grantRole(
        address _to,
        bytes32 _role
    ) external onlyRole(ADMIN) {
        require(
            isActive[_role] == true,
            "Role not found"
        );
        require(
            role[_role][_to] == false,
            "User already have the role"
        );

        role[_role][_to] = true;

        emit RoleGranted(
            _to,
            _role
        );
    }

    function revokeRole(
        address _to,
        bytes32 _role
    ) external onlyRole(ADMIN) {
        require(
            role[_role][_to] == true,
            "User does not have the role"
        );

        role[_role][_to] = false;

        emit RoleRevoked(
            _to,
            _role
        );
    }

    function addRole(
        string calldata _role
    ) external onlyRole(ADMIN) {
        require(
            bytes(_role).length > 0,
            "Invalid string"
        );
        bytes32 newRole = keccak256(bytes(_role));
        require(
            isActive[newRole] == false,
            "Role already added"           
        );

        isActive[newRole] = true;
        roles.push(_role);

        emit RoleAdded(_role);
    }

    function getAllRoles() external view returns(string[] memory allRoles) {
        allRoles = roles;
    }
}