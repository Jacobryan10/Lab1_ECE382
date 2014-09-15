##Lab1_ECE382
===========

Title: Lab 1 for ECE 382

The objective of this lab was to create a assembly language calculator that would start reading at the location in ROM wheret the calculator instructions were stored. It will read the first byte as the first operand. The next byte will be an operation. The third byte will be the second operand. The program will execute the expected operation and store the result starting at 0x0200. The result will then be the first operand for the next operation. The next byte will be an operation. The following will be the second operand. Your program will execute the requested operation and store the result at 0x0201. Your program will continue doing this until you encounter an END_OP - at which point, your program will cease execution.


 •Software flow chart / algorithms
 
 ![alt text] (http://i61.tinypic.com/x37ihs.jpg)
 
 •Well-formatted code
 The code can be found as an attached file in the repository
 
 •Debugging
 To debug, I would first run the program and check for the right answers. If I did not get the right answer, I would then look to see where I went wrong by looking at the results in the address locations/registers. Then I would install breakpoints and step through bits of the instructions to see where I went wrong. Usually the problem was not assigning values to a register/address at the right time, or I would store the wrong value. Once I got those corrected, the rest of the program ran smoothly
 
 •Testing methodology / results
 I used the test code provided by the Lab to check my answers. I would then check the address locations starting at 0x200 to see if I got the right results. If I did I would move to the next case, otherwise I would go back to debugging. The program worked as expected.
 
 •Observations and Conclusions
 The program worked as expected, multiplication could have been faster by doing bitwise calculations as mentioned by Capt Trimble and with more time I think I could have implemented it.
 
 •Documentation
 C2C Leaf helped me manipulate the rom registers through the use of post increments. 
