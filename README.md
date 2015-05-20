# Poet: A Writer Monad for Swift

You have a restaurant, and a menu with a few drinks. Once a customer wants to leave you need to calculate the total price of all the drinks and print a receipt.
```swift
struct Drink {
    let name: String, price: Int
}
    
struct Checkout {
    let drinks: [Drink]
    
    func add(drink: Drink, count : Int = 1) -> Checkout {
        return Checkout(drinks: drinks + [Drink](count: count, repeatedValue: drink))
    }
        
    var total: Int {
        return drinks.map { $0.price } .reduce(0, combine: +)
    }
}
    
let menu = (
    beer: Drink(name: "Schneider Weisse", price: 350),
    mate: Drink(name: "Club Mate", price: 250),
    coke: Drink(name: "Fritz Cola", price: 270)
)
```

First you create a receipt writer that will write a checkout you will build to a String:

```swift
typealias ReceiptWriter = Writer<String, Checkout>

let pure = ReceiptWriter.pure
let tell = ReceiptWriter.tell
```

Then you start by defiing a function to add a drink to a checkout and write the line in the receipt

```swift
func addDrink(drink: Drink, count : Int = 1)(checkout: Checkout) -> ReceiptWriter {
    return Writer(checkout.add(drink, count: count), "\(drink.name) ⨉ \(count): \(drink.price * count)\n")
}
```
    
All that is left to do is write the whole receipt step by step:

```swift
let newCheckout = Checkout(drinks: [])
    
let writer = pure(newCheckout)
    >>= tell("17 May, 2015\n")
    >>= tell("\n")
    >>= tell("🍺 Alcoholic drinks\n")
    >>= addDrink(menu.beer, count: 3)
    >>= tell("\n")
    >>= tell("☕️ Non-alcoholic drinks\n")
    >>= addDrink(menu.mate)
    >>= addDrink(menu.coke)
    >>= tell("\n")
    >>= tell("Thank you for your visit...\n")
    
let (checkout, receipt) = writer.run()

checkout.total # => 1570
receipt # =>

# 17 May, 2015
# 🍺 Alcoholic drinks
# Schneider Weisse ⨉ 3: 1050
#
# ☕️ Non-alcoholic drinks
# Club Mate ⨉ 1: 250
# Fritz Cola ⨉ 1: 270
# 
# Thank you for your visit...
```

Beautiful. Everything is pure and immutable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
