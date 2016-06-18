JBKeyboardPicker
================

An extensible Keyboard picker for iOS applications.

Demo
----

The code to use this control is in the `ExampleProject/` directory:


You could instead clone the project and copy the JBKeyboardPicker/JBKeyboardPicker.Swift files into your project.


Initialization
--------------

Adding JBKeyboardPicker to your project is as simple as getting the source files, and waving a magic wand:

``` Swift
    override func viewDidLoad() {
        ...
        let Keyboardview = KeyboardPicker()
        Keyboardview.Values = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        TextField1.inputView = Keyboardview
        ...
    }
```


Options
-------

JBKeyboardPicker is made to be very easy to customize.

###Properties

You can set the options with:

####Values : [String]! 

With JBKeyboardPicker, the Values is a array which contains the options or values to be displays in keyboard.

You can set the options with:

```Swift
    Keyboardview.Values = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
```

####var RowSelected: Int - Default  0 

Whenever the picker values changes, this value will change. It will be a normalized value based selected value in picker.

You can get the Selected value with:

```Swift
    Keyboardview.RowSelected = 2
```

Screenshot
----------

<p align="center">
  <img src="example.jpg?raw=true">
</p>

About the developer
-------------------

If you like this control, [follow @bnp1711 on twitter] or [http://www.facebook.com/it4ufriends] on Facebook and let me know!


License
-------

Copyright (c) 2016 Bhavesh Patel

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.