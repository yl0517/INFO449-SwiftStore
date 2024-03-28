# UW Homework: Swift Store
This homework is designed to force you to simultaneously exercise your knowledge of the Swift programming language and address some interesting design problems that often appear in programming (also known as "business rules"). It does not involve iOS in any way.

## Greetings!
This homework is designed to force you to exercise your knowledge of the Swift programming language.

In this exercise, you will implement a (relatively) simple point-of-sale register for a grocery store. The different ways that grocery stores sell things makes this somewhat complicated, and as a result, much of this homework is intended as an extra credit opportunity (and a software design challenge.) Note that you will not only be required to write the implementation code, but also the unit tests that make sure your code behaves as desired. You must complete both code and some tests in order to obtain credit for a given task.

> This is actually one of the "Code Katas" discussed [here](http://codekata.com/kata/kata01-supermarket-pricing/). However, unlike Dave's Kata, I require coding. :-) More importantly, this is a common exercise developers go through to practice their design skills, and more than once something like this has shown up in an engineering interview process. For extra fun (on your own time), write the assignment a second time using Java, and/or Kotlin, and/or C#, and/or Dart.... The purpose of the exercise is to help you learn how different features of your chosen programming language can be used to design and implement non-trivial requirements.

## To get started...
... you must first obtain a copy of the source. You do that by cloning this repository. Two options are available to you:

1. **Fork this repository.** From the GitHub repository web page, click "Fork" in the upper-right. This will create a copy of this repository in your own GitHub account. From there do a `git clone` from your own copy of the GitHub repository. (If you are unsure of the clone syntax, open the new repository in your account from the web, and click the green "Code" button--it will offer the correct syntax to use.)

2. **Clone and re-home this repository.** Open a "Command Prompt" or "Terminal" instance and use:

        git clone https://github.com/tedneward/INFO449-SwiftStore

    ... to do the deed. This will also create a local copy of the project on your machine in a directory called `INFO449-SwiftStore`. You will also need to "re-home" your local copy so it points to your own GitHub account; you can do this by creating a repository of this same name (`INFO449-SwiftStore`) in your GitHub account and then executing `git remote set-url origin https://github.com/[your-ID]/INFO449-SwiftStore.git`. (Needless to say, it's a lot easier to fork the repo.)

    In order to store your changes to your own GitHub account, you need to create a new repository on GitHub (call it `INFO449-SwiftStore`), and then change the project's settings to point to that new repository as the remote origin.

        git remote set-url origin https://github.com/[your-ID]/INFO449-SwiftStore.git

    Note, this will appear to succeed whether you got the syntax of the URL correct or not, so do a quick push to make sure it all worked correctly:

        git push

    Git will ask you for your username and password, then (if everything was done correctly), it will upload the code to the new repository, and this is your new "home" for this project going forward. Verify the files are there by viewing your GitHub project through the browser.


## To work on the code...
Open the project in XCode. It is set up as a console application that uses some unit tests to verify that the code works, though you will need to add and/or modify the tests.

Implement the following:

* All items sold in the store have a "stock keeping unit" (SKU) number associated with them. When the item is swiped over the barcode scanner, the tag on the item sends the SKU to the Register, where it is looked up and added to the Receipt. To support this, you need to:
    * Implement `SKU` as a protocol. It should require a property `name` that retrieves the name of the item, and a method `price` that returns the price (as an Int, in USD pennies).
    * When a `Register` is created, have it create a `Receipt` on which to capture all the items scanned.
    * On the `Register` class, implement a `scan` method that takes a `SKU` as a parameter, and add the SKU to the `Receipt`.

* The `Register` is responsible for displaying the total along the way, so you need to:
    * Implement a `subtotal` method that returns the current total for all the items on the Receipt.
    * Implmement a `total` method that returns the Receipt (which contains all the items scanned), and clears its state to start a new Receipt. (In other words, `subtotal` displays the price along the way, whereas `total` is the finished transaction.)

* The `Receipt` is a list of the entire transaction.
    * Implement an `items` method that returns the list of SKUs that were scanned.
    * Implement an `output` method to print out all of the items stored on the Receipt.

* Create a class `Item` that implements `SKU` and uses a price-per-item pricing scheme. That is to say, a $4.99 can of beans (an `Iten("Beans", 499)`) or a $.99 pencil (a `Item("Pencil", 99)`).
    * Create a unit test that tests adding a single Item to the Register and displays its subtotal (which should be the single Item's price).

## Now for the fun part
This is just the tip of the iceberg. Implementing each of these--and their corresponding unit tests--is worth 2 extra credit points. Note that these are not necessarily easy, and hte moer of them you do, the more you will feel the weight of poor design making your code more complex and difficult to extend/enhance. If that happens to you, it's OK, that's why these are extra credit, but it helps make it clear why we generally want to think some before just churning out code.

* **2-for-1 Pricing:** Stores and manufacturers will often offer "bunched pricing", such that you can buy a can of beans by itself at $1.99, or three of them for $2.98 (2-for-1, also known as "buy two, get one free"). Implement a `PricingScheme` that can be added to the `Register` so that from this point forward, any purchase of three of a particular kind of good will change the price to only two of them.
    * There are no limits to the number of times that can apply to a single Receipt, so long as the good in question is on the Receipt. However, the core criteria must be met--if the 2-for-1 is for "Can of beans", and there is only one "Can of beans" on the Receipt, it does not kick in. If there are two "Can of beans" on the Receipt, then the pricing kicks in but the customer doesn't get a third "Can of beans" unless that is scanned.
    * 

* **Grouped purchases:** Stores often find that customers will buy certain items at the same time (ketchup and mustard, for example), and other items are never purchased at the same time (beer and kitty litter, for example). In order to subtly encourage more purchasing, stores will offer "grouped pricing", such that if you buy ketchup and beer, you can get 10% off of each. (The theory being, if you're buying ketchup, you'll probably buy mustard, so now you're buying beer, ketchup, and mustard, instead of just beer or just ketchup and mustard). Implement a `PricingScheme` that recognizes when its criteria is met (purchasing both ketchup and beer) and take 10% off of each of those two goods.
    * A given PricingScheme should be flexible in its criteria; for example, "ketchup and beer" can include all different varieties of beer, and all different sizes and/or vendors of ketchup.
    * There are no limits to the number of times this can apply to a single Receipt.

* **Priced by weight:** Some items, like fruit, meat, or vegetables, are often priced by weight. A steak will be $8.99 per pound, for example, and then wrapped in packaging that offers a variety of different weights. One packages will be 1.1 pounds, for example, while another is 1 pound, and a third 0.95 pounds. In other cases, apples and other fruits are weighed at the register. Implement a class or classes that allow us to buy fruit, meat, and/or veg. 

* **Coupons:** Manufacturers of various goods often offer coupons on their goods at stores, and the stores themselves will often run a special. Implement a `Coupon` class that offers a discount (let's assume it's always 15%) on the price of one particular good (such as "apples" or "beans"). Any good of that name is acceptable to receive the discounted price, but it only applies to one line-item on the Receipt. Thus, if the Coupon is 15% off of beans, and the Receipt has two Items("Can of beans") on it, one of those two items should be 15% off.

* **Rain checks:** Often, when a store runs out of an item on a special price, rather than simply turn the customer away empty-handed, they will issue a "rain check" that promises to honor that price (whether the special is still running or not) when the customer returns to purchase that item. It cannot be used for other goods, and it only substitutes in that new price for that particular good. Implement a `RainCheck` class that, when scanned, looks for the good it was issued for (a SKU), and substitutes its price for the scanned good's price. 
    * If the good is not on the Receipt, the RainCheck has no effect.
    * RainChecks only substitude for one of the good. If you have implemented **Bunched pricing** or **Priced-by-weight**, you'll need the RainCheck to specify how much it covers (the quantity or weight, as the case may be).

* **Tax:** Certain items are Taxable, certain items are not. Implement a protocol `Taxable` and a method on that protocol called `tax` that calculates tax for a given SKU. Any items scanned by the Register that are Taxable must also capture the tax as part of the subtotal, and list the total tax as a line item by itself on the Receipt, so that the output reads "item...cost item...cost subtotal...amount tax...amount total...amount".
    * Assume that any item which is edible (beans, bananas, etc) is not taxed.
    * Assume that any non-edible item (pencils, light bulbs, etc) are taxed at a rate of 10%.
    * Tax often produces "fractions of a penny" when calculating--a 10% tax on a $.99 item yields a tax of $.099. What do we do with the fraction of a penny? Round up? Round down? Round to the nearest integer (up if it's over .5, otherwoise down)? Document your decision and test for it, so that the decision is consistent and remains that way in the face of any future evolution.
    * If you've implemented any of the other extra credit items, make sure Taxable works with each of them. Pay particularly close attention to **Rain Checks** and **Coupons**!





