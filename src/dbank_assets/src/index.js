//bridge between index.js and main.mo
import {dbank} from "../../declarations/dbank"; //access to the functions I made in main.mo and call them here

//update current value whenever page is loaded by updating span (index.html)
window.addEventListener("load", async function() {
  // console.log("Finished loading")
  update();
}); //used window to get current balance whenever page is loaded

//listen from the form
document.querySelector("form").addEventListener("submit", async function(event) {
  event.preventDefault(); //prevent page from being reloaded when button clicked

  // console.log("submitted")

  //Disable button while change is coming up in UI
  const button = event.target.querySelector("#submit-btn");


  //what users typed in the forms
  const inputAmount = parseFloat(document.getElementById("input-amount").value); //by default value comes out as integer but should change to float as I set up in main.mo (use parseFloat)
  const withdrawAmount = parseFloat(document.getElementById("withdrawal-amount").value);

  //Disable button
  button.setAttribute("disabled", true); //create class in index.html

  //trigger functions topUp and widthdraw in main.mo
  if (document.getElementById("input-amount").value.length != 0) {
    await dbank.topUp(inputAmount); 
  };//!= 0 means user typed something

  if (document.getElementById("withdrawal-amount").value.length != 0) {
    await dbank.withdraw(withdrawAmount);
  }; //can use else
  
  //compund balance by interest after user add or withdraw money
  await dbank.compound();

  //to see new balance in UI check balance and update
  update();

  //remove input value is removed once it has been uploaded
  document.getElementById("input-amount").value = "";
  document.getElementById("withdrawal-amount").value = "";

  //as soon as the value is updated, the button is back to active
  button.removeAttribute("disabled");

}); //triggered when submit button clicked

//remove repetitive function above
async function update() {
  const currentAmount = await dbank.checkBalance();
  document.getElementById("value").innerText = Math.round(currentAmount * 100) / 100; //devided by 100 to get two decimal places
};
