//import assertRevert from "openzeppelin-solidity/test/helpers/assertRevert";

const LemonadeSale = artifacts.require("LemonadeSale");

contract("LemonadeFactory", accounts => {
  it("Should make first account an owner", async () => {
    let instance = await LemonadeSale.deployed();
    let owner = await instance.owner();
    assert.equal(owner, accounts[0]);
  });

  describe("mint", () => {
    it("creates Lemonade and mints a token", async () => {
      let instance = await LemonadeSale.deployed();

      await instance.createLemonade("YellowOne", 188);

      let ing = await instance.getLemonadeIngredients(0);
      assert.equal(ing, 188);
    });
  });
});