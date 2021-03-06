struct Address {
	var streetAddress: String
	
	var city: String
	
	var state: String
	
	var postalCode: String
}

class Person {
	var name: String
	
	var address: Address
	
	init(name: String, address: Address) {
		self.name = name
		self.address = address
	}
}

// 1
let kingsLanding = Address(streetAddress: "1 King Way", city: "Kings Landing", state: "Westeros", postalCode: "12345")
let madKing = Person(name: "Aerys", address: kingsLanding)
let kingSlayer = Person(name: "Jaime", address: kingsLanding)

// 2
kingSlayer.address.streetAddress = "1 King Way Apt. 1"

// 3
madKing.address.streetAddress
kingSlayer.address.streetAddress

struct Bill {
	let amount: Float
	
	// 1
	private var _billedTo: Person
	
	// 2
	private var billedToForRead: Person {
		return _billedTo
	}
	
	// 3
	private var billedToForWrite: Person {
		mutating get {
			if !isKnownUniquelyReferenced(&_billedTo) {
				print("Making a copy of _billedTo")
				_billedTo = Person(name: _billedTo.name, address: _billedTo.address)
			} else {
				print("Not making a copy of _billedTo")
			}
			return _billedTo
		}
	}
	
	init(amount: Float, billedTo: Person) {
		self.amount = amount
		// Create a new Person reference from the parameter
		_billedTo = Person(name: billedTo.name, address: billedTo.address)
	}
	
	mutating func updateBilledToAdress(address: Address) {
		billedToForWrite.address = address
	}
	
	mutating func updateBilledToName(name: String) {
		billedToForWrite.name = name
	}
}

// 1
let billPayer = Person(name: "Robert", address: kingsLanding)

// 2
let bill = Bill(amount: 42.99, billedTo: billPayer)

let bill2 = bill

// 3
//billPyer.name = "Bob"
//bill.billedTo.name = "Bob"

// Inspect values
//bill.billedTo.name
//bill2.billedTo.name

var myBill = Bill(amount: 99.99, billedTo: billPayer)
var billCopy = myBill

myBill.updateBilledToName(name: "Eric")


		