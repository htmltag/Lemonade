var LemonadeSale = artifacts.require("LemonadeSale");
var LemonadeFactory = artifacts.require("LemonadeFactory");

module.exports = function(deployer) {
    deployer.deploy(LemonadeFactory);
    deployer.deploy(LemonadeSale);
};