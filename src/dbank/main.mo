import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Float "mo:base/Float";

actor DBank {
  stable var currentValue: Float = 300; //by default numbers are Nat //stable to make value persisted(flexible)-> not gonna be reset whenever being deployed (restore previous state)
  currentValue := 300; //change value (var not let) // := regardless what previous value was, it will go back to 100 when ebing deployed/turn it off
  Debug.print(debug_show (currentValue));

  let id = 123412555664; //same as const value never changed
  // Debug.print(debug_show (id));

  stable var startTime = Time.now(); //current time in nanosecond since 1971/1/1
  startTime := Time.now();
  Debug.print(debug_show (startTime));


  public func topUp(amount: Float) {
    currentValue += amount;
    Debug.print(debug_show (currentValue)); //print changed value in the console
  };
  // topUp(); //call the function internally //to call the function externally must use public
  // must give data type (Nat) if the function has return value

  public func withdraw(amount: Float) {
    let tempValue: Float = currentValue - amount; //Int can be any whole number in possitive and negative //to give same type to the subtracted amount
    //prevent violation of type error, use conditionals
    if (tempValue >= 0) {
      currentValue -= amount;
      Debug.print(debug_show (currentValue));
    } else {
      Debug.print(debug_show ("Amount is too large. Current value is less than zero."));
    }
  };

  public query func checkBalance(): async Float {
    return currentValue; //query: read only cannot change anything
  }; //output (return value) mnust come out asyncronously

  public func compound() {
    let currentTime = Time.now();
    let timeElapsedNS = currentTime - startTime;
    let timeElapsedS = timeElapsedNS / 1000000000; //nanosecond in second

    currentValue := currentValue * (1.01 ** Float.fromInt(timeElapsedS)); 
    //type of numbers in the equation (timeElapedS) must match to be calculated 1.01(float) //money should be in float not whole number(nat)

    startTime := currentTime;
    //Reset startTime(beginning of program running) and change to currentTime to compund(add) money on the money compunded in the previous time

  }



}